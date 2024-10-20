#!/usr/bin/fish

for dir in $PWD/nvim/pack/nvim/start/*/
  echo "$dir"
  cd "$dir"
  set main (git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git fetch
  git reset --hard "origin/$main"
  cd -
  git add "$dir"
end

