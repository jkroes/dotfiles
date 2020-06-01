#!/usr/bin/env fish

echo (pwd)

for f in (find dotfiles -mindepth 1 -printf '%P\n')
	# Make missing directories
	if test -d "dotfiles/$f"
		if test ! -e $f
			echo "Making dir $f"
			mkdir $f
		end
	# Copy files, overwriting existing files
	else
		cp "dotfiles/$f" "$f"
	end
end

#find dotfiles -mindepth 1 -type f -printf '
