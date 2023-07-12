#!/bin/bash

#Install yay and other drivers
echo "Installing yay and other drivers..."
cd
cd Documents
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S curl cabextract
cd 
cd Documents
git clone https://github.com/medusalix/xone
cd xone
sudo ./install.sh --release
sudo xone-get-firmware.sh

sudo pacman -S git cmake hidapi
cd
cd Documents
git clone https://github.com/Sapd/HeadsetControl && cd HeadsetControl
mkdir build && cd build
cmake ..
make
sudo make install

sudo udevadm control --reload-rules && sudo udevadm trigger

#Now install stuff from the AUR
echo "Installing utilities from the AUR"
yay -S visual-studio-code-bin google-chrome
yay -S ttf-ms-win11-auto
sudo fc-cache --force

#Gaming and stuff
echo "Installing programs for gaming..."
sudo pacman -S steam lutris discord
sudo pacman -S gamemode lib32-gamemode

#Install some other stuff
echo "Installing other utilities..."
sudo pacman -S neofetch htop
flatpak install flathub sh.cider.Cider

#Install refind
echo "Installing refind boot manager..."
sudo pacman -S refind
refind-install
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobafetthotmail/refind-theme-regular/master/install.sh)"
