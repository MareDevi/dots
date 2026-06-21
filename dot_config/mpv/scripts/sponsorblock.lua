-- sponsorblock.lua
--
-- This script skips sponsored segments of Bilibili videos
-- using data from https://bsbsb.top

local ON_WINDOWS = package.config:sub(1,1) ~= "/"

local options = {
    server_address = "https://bsbsb.top",

    python_path = ON_WINDOWS and "python" or "python3",

    -- Categories to fetch
    categories = "sponsor,selfpromo,interaction,intro,outro,preview,music_offtopic",

    -- Categories to skip automatically
    skip_categories = "sponsor",

    -- If true, sponsored segments will only be skipped once
    skip_once = true,

    -- Create chapters at sponsor boundaries for OSC display and manual skipping
    make_chapters = true,

    -- Minimum duration for sponsors (in seconds), segments under that threshold will be ignored
    min_duration = 1,

    -- Fade audio for smoother transitions
    audio_fade = false,

    -- Audio fade step, applied once every 100ms until cap is reached
    audio_fade_step = 10,

    -- Audio fade cap
    audio_fade_cap = 0,

    -- Fast forward through sponsors instead of skipping
    fast_forward = false,

    -- Playback speed modifier when fast forwarding, applied once every second until cap is reached
    fast_forward_increase = .2,

    -- Playback speed cap
    fast_forward_cap = 2,

    -- Length of the sha256 prefix (3-32) when querying server, 0 to disable
    sha256_length = 4,

    -- Pattern for BVID in local files, ignored if blank
    local_pattern = "",

    -- Legacy option, use skip_categories instead
    skip = true
}

mp.options = require "mp.options"
mp.options.read_options(options, "sponsorblock")

local legacy = mp.command_native_async == nil

local utils = require "mp.utils"
scripts_dir = mp.find_config_file("scripts")

local sponsorblock = utils.join_path(scripts_dir, "sponsorblock_shared/sponsorblock.py")
local bvid = nil
local cid = ""
local ranges = {}
local init = false
local speed_timer = nil
local fade_timer = nil
local fade_dir = nil
local volume_before = mp.get_property_number("volume")
local categories = {}
local chapter_cache = {}

for category in string.gmatch(options.skip_categories, "([^,]+)") do
    categories[category] = true
end

function t_count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function time_sort(a, b)
    if a.time == b.time then
        return string.match(a.title, "segment end")
    end
    return a.time < b.time
end

function create_chapter(chapter_title, chapter_time)
    local chapters = mp.get_property_native("chapter-list")
    local duration = mp.get_property_native("duration")
    table.insert(chapters, {title=chapter_title, time=(duration == nil or duration > chapter_time) and chapter_time or duration - .001})
    table.sort(chapters, time_sort)
    mp.set_property_native("chapter-list", chapters)
end

function process(uuid, t, new_ranges)
    start_time = tonumber(string.match(t, "[^,]+"))
    end_time = tonumber(string.sub(string.match(t, ",[^,]+"), 2))
    for o_uuid, o_t in pairs(ranges) do
        if (start_time >= o_t.start_time and start_time <= o_t.end_time) or (o_t.start_time >= start_time and o_t.start_time <= end_time) then
            new_ranges[o_uuid] = o_t
            return
        end
    end
    category = string.match(t, "[^,]+$")
    if categories[category] and end_time - start_time >= options.min_duration then
        new_ranges[uuid] = {
            start_time = start_time,
            end_time = end_time,
            category = category,
            skipped = false
        }
    end
    if options.make_chapters and not chapter_cache[uuid] then
        chapter_cache[uuid] = true
        local category_title = (category:gsub("^%l", string.upper):gsub("_", " "))
        create_chapter(category_title .. " segment start (" .. string.sub(uuid, 1, 6) .. ")", start_time)
        create_chapter(category_title .. " segment end (" .. string.sub(uuid, 1, 6) .. ")", end_time)
    end
end

function getranges(_, _, _, more)
    local sponsors
    local args = {
        options.python_path,
        sponsorblock,
        "ranges",
        "",
        options.server_address,
        bvid,
        options.categories,
        tostring(options.sha256_length),
        cid
    }
    if not legacy then
        sponsors = mp.command_native({name = "subprocess", capture_stdout = true, playback_only = false, args = args})
    else
        sponsors = utils.subprocess({args = args})
    end
    mp.msg.debug("Got: " .. string.gsub(sponsors.stdout, "[\n\r]", ""))
    if not string.match(sponsors.stdout, "^%s*(.*%S)") then return end
    if string.match(sponsors.stdout, "error") then return end
    local new_ranges = {}
    local r_count = 0
    if more then r_count = -1 end
    for t in string.gmatch(sponsors.stdout, "[^:%s]+") do
        uuid = string.match(t, "([^,]+),[^,]+$")
        if ranges[uuid] then
            new_ranges[uuid] = ranges[uuid]
        else
            process(uuid, t, new_ranges)
        end
        r_count = r_count + 1
    end
    local c_count = t_count(ranges)
    if c_count == 0 or r_count >= c_count then
        ranges = new_ranges
    end
end

function fast_forward()
    if options.fast_forward and options.fast_forward == true then
        speed_timer = nil
        mp.set_property("speed", 1)
    end
    local last_speed = mp.get_property_number("speed")
    local new_speed = math.min(last_speed + options.fast_forward_increase, options.fast_forward_cap)
    if new_speed <= last_speed then return end
    mp.set_property("speed", new_speed)
end

function fade_audio(step)
    local last_volume = mp.get_property_number("volume")
    local new_volume = math.max(options.audio_fade_cap, math.min(last_volume + step, volume_before))
    if new_volume == last_volume then
        if step >= 0 then fade_dir = nil end
        if fade_timer ~= nil then fade_timer:kill() end
        fade_timer = nil
        return
    end
    mp.set_property("volume", new_volume)
end

function skip_ads(name, pos)
    if pos == nil then return end
    local sponsor_ahead = false
    for uuid, t in pairs(ranges) do
        if (options.fast_forward == uuid or not options.skip_once or not t.skipped) and t.start_time <= pos and t.end_time > pos then
            if options.fast_forward == uuid then return end
            if options.fast_forward == false then
                mp.osd_message("[sponsorblock] " .. t.category .. " skipped")
                mp.set_property("time-pos", t.end_time)
            else
                mp.osd_message("[sponsorblock] skipping " .. t.category)
            end
            t.skipped = true
            if options.fast_forward ~= false then
                options.fast_forward = uuid
                if speed_timer ~= nil then speed_timer:kill() end
                speed_timer = mp.add_periodic_timer(1, fast_forward)
            end
            return
        elseif (not options.skip_once or not t.skipped) and t.start_time <= pos + 1 and t.end_time > pos + 1 then
            sponsor_ahead = true
        end
    end
    if options.audio_fade then
        if sponsor_ahead then
            if fade_dir ~= false then
                if fade_dir == nil then volume_before = mp.get_property_number("volume") end
                if fade_timer ~= nil then fade_timer:kill() end
                fade_dir = false
                fade_timer = mp.add_periodic_timer(.1, function() fade_audio(-options.audio_fade_step) end)
            end
        elseif fade_dir == false then
            fade_dir = true
            if fade_timer ~= nil then fade_timer:kill() end
            fade_timer = mp.add_periodic_timer(.1, function() fade_audio(options.audio_fade_step) end)
        end
    end
    if options.fast_forward and options.fast_forward ~= true then
        options.fast_forward = true
        speed_timer:kill()
        speed_timer = nil
        mp.set_property("speed", 1)
    end
end

function find_bvid(text)
    if text == nil then return nil end
    local found = string.match(text, "(BV[%w]+)")
    if found and string.len(found) >= 12 then
        return string.sub(found, 1, 12)
    end
    return nil
end

function find_cid(video_path, video_referer)
    local metadata = mp.get_property_native("metadata") or {}
    for _, key in ipairs({"cid", "bilibili_cid", "Bilibili CID", "bilibili-cid"}) do
        if metadata[key] then
            return tostring(metadata[key])
        end
    end

    local cid_from_url = string.match(video_path, "[?&]cid=(%d+)") or string.match(video_referer, "[?&]cid=(%d+)")
    return cid_from_url or ""
end

function file_loaded()
    local initialized = init
    ranges = {}
    chapter_cache = {}

    local video_path = mp.get_property("path", "")
    mp.msg.debug("Path: " .. video_path)
    local video_referer = string.match(mp.get_property("http-header-fields", ""), "Referer:([^,]+)") or ""
    mp.msg.debug("Referer: " .. video_referer)

    bvid = find_bvid(video_path) or find_bvid(video_referer)
    if not bvid and options.local_pattern ~= "" then
        bvid = string.match(video_path, options.local_pattern)
        if bvid and not string.match(bvid, "^BV[%w]+$") then
            bvid = find_bvid(bvid)
        end
    end

    if not bvid then return end

    cid = find_cid(video_path, video_referer)
    mp.msg.debug("Found BVID: " .. bvid .. (cid ~= "" and (" CID: " .. cid) or ""))

    init = true
    getranges(true, true)

    if initialized then return end
    if options.skip then
        mp.observe_property("time-pos", "native", skip_ads)
    end
end

mp.register_event("file-loaded", file_loaded)
