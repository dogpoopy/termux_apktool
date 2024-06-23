#!/bin/bash

# Install necessary packages
yes | pkg install openjdk-17
yes | pkg install wget
yes | pkg install curl
yes | pkg install jq

current_dir=$(pwd)

download_apktool() {
    wget -O "$current_dir/apktool.jar" "$1"
}

# Get the latest release of apktool.jar from GitHub
release_info=$(curl -s 'https://api.github.com/repos/iBotPeaches/Apktool/releases/latest')
latest_release=$(echo "$release_info" | jq -r '.assets[] | select(.name | endswith(".jar")) | .browser_download_url')

download_apktool "$latest_release"

if [ ! -s "$current_dir/apktool.jar" ]; then
    echo "Download from GitHub failed or file size is zero."
    read -p 'You can download the latest apktool.jar from https://apktool.org and put it inside the cloned folder "apktool". Continue? (y/n)' answer
    if [ "$answer" != "y" ]; then
        echo "Exiting the script."
        exit 1
    fi
fi

# Check if apktool and apktool.jar exist
if [ -f "$current_dir/apktool" ] && [ -f "$current_dir/apktool.jar" ]; then
    cp "$current_dir/apktool" "$PREFIX/bin/apktool"
    echo "Setting up apktool..."

    cp "$current_dir/apktool.jar" "$PREFIX/bin/apktool.jar"
    echo "Setting up apktool.jar..."
else
    echo "Either apktool or apktool.jar does not exist. Setup cannot continue."
    exit 1
fi

if [ -f "$PREFIX/bin/apktool" ]; then
    chmod +x "$PREFIX/bin/apktool"
else
    echo "Failed to find apktool in $PREFIX/bin. Setup cannot continue."
    exit 1
fi

