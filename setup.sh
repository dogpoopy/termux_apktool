#!/bin/bash

# Install necessary packages
yes | pkg install openjdk-17
yes | pkg install wget
yes | pkg install curl
yes | pkg install jq

current_dir=$(pwd)

# Get the latest release of apktool.jar
release_info=$(curl -s 'https://api.bitbucket.org/2.0/repositories/iBotPeaches/apktool/downloads/')
latest_release=$(echo "$release_info" | jq -r '.values[0] | .links.self.href')
wget -O "$current_dir/apktool.jar" "$latest_release"

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

