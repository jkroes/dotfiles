#!/usr/bin/env fish

switch (uname)
    case Darwin
	# GNU find needed for install script
	cp .config/fish/config.fish ~/.config/fish/config.fish
end

for f in (find dotfiles -mindepth 1 -printf '%P\n')
	# Make missing directories
	if test -d "dotfiles/$f"
		if test ! -e $f
			echo "Making dir $f"
			mkdir $f
		end
	# Copy files, overwriting existing files
	else
                echo "Copying dotfiles/$f to $f"
		cp "dotfiles/$f" "$f"
	end
end

#find dotfiles -mindepth 1 -type f -printf '
