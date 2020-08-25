# rust
set -g fish_user_paths ~/.cargo/bin $fish_user_paths

# nvim
set -g fish_user_paths ~/apps/nvim/usr/bin $fish_user_paths

# nvr
set -g fish_user_paths ~/.local/bin $fish_user_paths

# My own scripts
set -g fish_user_paths ~/Projects/cheatR $fish_user_paths

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
set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths

# emacs ansi-term support
if test -n "$EMACS"
  set -x TERM eterm-color
end

# this function may be required by ansi-term
function fish_title
  true
end