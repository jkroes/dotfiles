# Defined in - @ line 1
# Calling with a file argument here doesn't prevent git from using nvim as a commit editor
# unlike callineg `e $MYVIMRC` within init.vim
function nvim --wraps='~/apps/nvim/usr/bin/nvim' --description 'alias nvim ~/apps/nvim/usr/bin/nvim'
  ~/apps/nvim/usr/bin/nvim $argv
  # ~/apps/nvim/usr/bin/nvim  ~/.config/nvim/init.vim;
end
