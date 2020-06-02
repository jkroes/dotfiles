# rust
set -g fish_user_paths ~/.cargo/bin $fish_user_paths

# nvim
set -g fish_user_paths ~/apps/nvim/usr/bin $fish_user_paths

# nvr
set -g fish_user_paths ~/.local/bin $fish_user_paths

# WSL
if set -q WSL_DISTRO_NAME
    set -g fish_help_browser '/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe'
end
