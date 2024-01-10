https://github.com/wbthomason/packer.nvim

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

nvim 起動して、`:PackerInstall` とか `:PaclerSync` とかする

必要なら `ssh-add /Users/user_name/.ssh/id_rsa`


missing xcrun とか出たら
xcode-select --install
xcode-select --reset