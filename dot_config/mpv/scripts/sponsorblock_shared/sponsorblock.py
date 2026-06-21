import hashlib
import json
import sys
import urllib.error
import urllib.parse
import urllib.request

USER_AGENT = "mpv_sponsorblock_for_bilibili/1.0"
ORIGIN = "mpv_sponsorblock_for_bilibili"
EXT_VERSION = "mpv_sponsorblock_for_bilibili/1.0"

opener = urllib.request.build_opener()
opener.addheaders = [
    ("User-Agent", USER_AGENT),
    ("origin", ORIGIN),
    ("x-ext-version", EXT_VERSION),
]
urllib.request.install_opener(opener)

def wanted_segment(segment, bvid, cid):
    if segment.get("actionType") != "skip":
        return False
    if cid and str(segment.get("cid", "")) != cid:
        return False
    return segment.get("videoID", bvid) == bvid


def append_segment(times, segment, bvid, cid):
    if not wanted_segment(segment, bvid, cid):
        return
    start, end = segment["segment"]
    times.append(",".join([str(start), str(end), segment["UUID"], segment["category"]]))


def query_ranges(server_address, bvid, categories, sha256_length, cid):
    sha = None
    if 3 <= sha256_length <= 32:
        sha = hashlib.sha256(bvid.encode()).hexdigest()[:sha256_length]

    params = [("categories", json.dumps(categories))]
    if cid:
        params.append(("cid", cid))

    if sha:
        path = "/api/skipSegments/" + sha + "?"
    else:
        path = "/api/skipSegments?videoID=" + urllib.parse.quote(bvid) + "&"

    response = urllib.request.urlopen(server_address + path + urllib.parse.urlencode(params), timeout=10)
    segments = json.load(response)
    times = []

    for item in segments:
        if sha:
            if item.get("videoID") != bvid:
                continue
            for segment in item.get("segments", []):
                append_segment(times, segment, bvid, cid)
        else:
            append_segment(times, item, bvid, cid)

    return times


if sys.argv[1] == "ranges":
    try:
        print(":".join(query_ranges(
            server_address=sys.argv[3],
            bvid=sys.argv[4],
            categories=sys.argv[5].split(","),
            sha256_length=int(sys.argv[6]),
            cid=sys.argv[7] if len(sys.argv) > 7 else "",
        )))
    except urllib.error.HTTPError as e:
        if e.code == 404:
            print("")
        else:
            print("error")
    except (TimeoutError, urllib.error.URLError, ValueError, KeyError, IndexError):
        print("error")
