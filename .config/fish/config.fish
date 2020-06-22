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

switch (uname)
    case Darwin
	# Use GNU find as find, rather than gfind
	# (https://formulae.brew.sh/formula/findutils)
	set -g fish_user_paths (brew --prefix)/opt/findutils/libexec/gnubin  $fish_user_paths
end
