#!/usr/bin/fish

if test -d $HOME/.config/nvim
  mv $HOME/.config/nvim $HOME/.config/nvim-bak
end

git submodule update --init
git submodule update
ln -s $PWD/nvim $HOME/.config/nvim
