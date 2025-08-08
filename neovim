git clone https://github.com/neovim/neovim

cd neovim
git fetch all
sudo apt-get install ninja-build gettext cmake curl build-essential
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux-x86_64.deb 
