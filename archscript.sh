#!/bin/bash

#Install yay and other drivers
echo "Installing paru and other drivers..."
cd ~/Documents
sudo pacman -S --needed git base-devel bluez bluez-utils ntfs-3g
sudo systemctl enable bluetooth.service
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
sudo sed -i '/^\[options\]$/a SkipReview' /etc/paru.conf

#Install drivers for xbox controller and headsets
sudo pacman -S curl cabextract
cd ~/Documents
git clone https://github.com/medusalix/xone
cd xone
sudo ./install.sh --release
sudo xone-get-firmware.sh

sudo pacman -S git cmake hidapi
cd ~/Documents
git clone https://github.com/Sapd/HeadsetControl && cd HeadsetControl
mkdir build && cd build
cmake ..
make
sudo make install

sudo udevadm control --reload-rules && sudo udevadm trigger

#Now install stuff from the AUR
echo "Installing utilities from the AUR"
paru -S visual-studio-code-bin ttf-firacode sf-fonts microsoft-edge-dev-bin ttf-cascadia-code-nerd ttf-inter vesktop-bin

echo -n "Install Thorium Browser? (y/n)"
read -r response

# Set default to Y if no response is given
response=${response:-Y}

# Check if the response is either Y or y
if [[ $response =~ ^([Yy]|YES|yes|Yes)$ ]]
then
    echo "Installing Thorium"
    paru -S thorium-browser-bin
else
    echo "Not installing Thorium"
fi

#Gaming and stuff
echo "Installing programs for gaming..."
sudo pacman -S steam lutris
sudo pacman -S gamemode lib32-gamemode

#Install some other stuff
echo "Installing other utilities..."
sudo pacman -S neofetch htop

#Install refind
echo "Installing refind boot manager..."
sudo pacman -S refind
refind-install
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobafetthotmail/refind-theme-regular/master/install.sh)"

#Copy games over
echo "Copying steam games over from Windows"
sudo mount /dev/nvme1n1p3 /mnt
cd /mnt/Windows/Fonts
sudo cp -r * /usr/share/fonts
sudo fc-cache -fv

#Good looking fonts
sudo ln -sf /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
echo "FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"" | sudo tee -a /etc/environment > /dev/null

reboot

