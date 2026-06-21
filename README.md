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
- Hyprland, Hypridle, Hyprlock, Hyprpaper, Waybar, Dunst, and wallpaper assets
- Neovim configuration
- GTK, Kvantum, xsettingsd, and Catppuccin theme assets
- Ghostty, mpv, yazi, zathura, btop, cava, fastfetch, bat, micro, lazygit, satty, and udiskie
- EasyEffects, pavucontrol, Okular, Atuin config, mise config, and selected Sunshine config
- VS Code user settings and snippets only
- Optional modern shell helpers: SwayNC, SwayOSD, Fuzzel, Matugen, Walker, and Hyprpicker configs/scripts
- Desktop autostart entries and MIME associations
- fcitx5 input method settings
- Kvantum theme selection
- XDG user directories
- Fish universal variables

## Secret policy

Credentials, browser or Electron app state, SSH/GPG material, GitHub CLI auth,
rclone config, WakaTime config, Sunshine credentials/state/logs, VS Code MCP
secrets/storage/history/sync data, Atuin history data, mise installs, and
similar files are intentionally excluded.
If a secret-backed config needs to be shared later, add it as a chezmoi template
or encrypted file after reviewing the generated source.

## Optional packages

The Hyprland config keeps fallbacks for systems without the newer shell helpers.
To enable SwayNC notifications, SwayOSD media indicators, Fuzzel launcher, and
Matugen wallpaper colors:

```sh
~/.config/hypr/scripts/setup/install-modern-shell
```
