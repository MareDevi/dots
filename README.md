# MareDevi dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Restore

```sh
chezmoi init --apply git@github.com:MareDevi/dots.git
```

## What is tracked

- Shell startup files: Bash and Zsh
- Git defaults and signing configuration
- Zed settings
- fcitx5 input method settings
- Kvantum theme selection
- XDG user directories
- Fish universal variables

## Secret policy

Credentials, browser or Electron app state, SSH/GPG material, GitHub CLI auth,
rclone config, WakaTime config, and similar files are intentionally excluded.
If a secret-backed config needs to be shared later, add it as a chezmoi template
or encrypted file after reviewing the generated source.

