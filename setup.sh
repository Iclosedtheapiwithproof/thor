#!/bin/bash

echo "Installing dependencies"

sudo apt-get update
sudo apt-get install openjdk-7-jdk git bison g++-multilib git gperf libxml2-utils make zlib1g-dev:i386 zip gradle curl redis-server dpkg-dev nodejs-legacy npm ack-grep

echo "Downloading latest Android SDK"

curl http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz -o ~/Downloads/android-sdk_r24.1.2-linux.tgz

echo "Unpacking latest Android SDK"

mkdir -p /home/$USER/android-sdk-linux
tar zxvf /home/$USER/Downloads/android-sdk_r24.1.2-linux.tgz -C /home/$USER/android-sdk-linux

echo "Installing Android SDK dependencies (build tools, SDKs, ...)"

# TODO

echo "Creating SD card"

mkdir /home/$USER/android_images
(cd /home/$USER/android-sdk-linux/tools && ./mksdcard -l mysd1 1024M /home/$USER/android_images/mysd1.img)

echo "Cloning Thor"

sudo mkdir -p /Volumes/Android4.4.3
sudo chown -R $USER /Volumes
git clone https://github.com/cs-au-dk/thor.git /Volumes/Android4.4.3/thor

echo "Getting test server dependencies"

(cd /Volumes/Android4.4.3/BacklogRunner && npm install)

echo "Initializing Thor"

(cd /Volumes/Android4.4.3/thor/Android && sudo ./init.sh)
echo "sdk.dir=/home/$USER/android-sdk-linux" >> Robotium2Espresso/local.properties

echo "Initializing applications"

echo "sdk.dir=/home/$USER/android-sdk-linux" >> Applications/AnyMemo/local.properties
echo "sdk.dir=/home/$USER/android-sdk-linux" >> Applications/Car-Cast/local.properties
echo "sdk.dir=/home/$USER/android-sdk-linux" >> Applications/com.numix.calculator/local.properties
echo "sdk.dir=/home/$USER/android-sdk-linux" >> Applications/Catroid-latest/local.properties
echo "sdk.dir=/home/$USER/android-sdk-linux" >> Applications/Paintroid/local.properties

echo "Downloading the instrumented Android images"

curl http://brics.dk/thor/files/android-images.zip -o /home/$USER/Downloads/android-images.zip
mkdir -p /Volumes/Android4.4.3/thor/Android/out/target/product/generic_x86
unzip /home/$USER/Downloads/android-images.zip -d /Volumes/Android4.4.3/thor/Android/out/target/product/generic_x86

echo "Setting ANDROID_HOME"

echo "ANDROID_HOME=/Volumes/Android4.4.3/thor/Android" >> /home/$USER/.bashrc
. /home/$USER/.bashrc
