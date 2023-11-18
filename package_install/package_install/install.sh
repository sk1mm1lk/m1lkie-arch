echo "#############################"
echo "#    Installing Packages    #"
echo "#############################"

# Packages
WINDOW_MANAGER = "i3-wm i3lock i3status nitrogen picom lightdm dunst"
TERMINALS      = "xterm terminator"
MEDIA          = "gimp darktable smplayer gthumb"
DOCUMENTS      = "atril libreoffice-fresh thunar neovim vim"
GAMES          = "steam 0ad"
TOOLS          = "tree unrar unzip wget curl r radare2 qbittorrent sudo keepassxc flameshot cronie"

echo "Window Manager Packages"
echo "Installing..."
pacman -S $WINDOW_MANAGER

echo "Terminals"
pacman -S $TERMINALS
#curl -sS https://starship.rs/install.sh | sh

