#!/bin/bash
cd ~/nvim-buga
cp -r ~/.config/nvim/lua . 
cp ~/.config/nvim/init.lua .
cp ~/.config/nvim/lazy-lock.json . 2>/dev/null || true
git add .
git commit -m "${1:-Update nvim config}"
git push
