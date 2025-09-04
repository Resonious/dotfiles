#!/usr/bin/fish

if test -d $HOME/.config/nvim
  mv $HOME/.config/nvim $HOME/.config/nvim-bak
end

ln -s $PWD/nvim $HOME/.config/nvim

echo done
