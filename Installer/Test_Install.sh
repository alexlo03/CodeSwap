#!/bin/bash
clear
echo "\033[01;32mUpdating...\033[00m\n"
sudo apt-get update -y # To get the latest package lists

#Unpacks curl archive



echo "\033[01;32mChanging to new curl directory\033[00m\n"
cd curl-7.21.3

echo "\033[01;32mConfiguring and checking for errors\033[00m\n"
./configure && make

echo "\033[01;32mMaking install\033[00m\n"
sudo make install -s
#bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
#curl -L get.rvm.io | bash -s stable


echo "\033[01;32mAcquiring dependencies for rvm\033[00m\n"
sudo apt-get install build-essential openssl libreadline6 libreadline6-dev libruby1.9.1 curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion -y

echo "\033[01;32mInstalling and Running rvm\033[00m\n"
command curl -L https://get.rvm.io  | bash -s stable --ruby
#curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer | bash

echo "\033[01;32mReloading RVM\033[00m\n"
command rvm reload

echo "\033mUsing rvm to install ruby version 1.9.3\033[00m\n"
#command rvm install 1.9.3

echo "\033[01;32mMaking rvm use 1.9.3 as the default version\033[00m\n"
command rvm use 1.9.3 --default

echo "\033[01;32mUpdating rubygems with rvm\033[00m\n"
command rvm rubygems current

echo "\033[01;32mInstalling rails\033[00m\n"
command gem install rails

echo "\033[01;32mDownloading & Installing node.js\033[00m\n"
git clone https://github.com/joyent/node.git
cd node
git checkout v0.6.18
./configure
make
sudo make install
cd

##REMOVED FOR INITIAL TESTING
#Download, install and launch the application
#git clone https://github.com/alexlo03/CodeSwap.git

echo "\033[01;32mMoving into CodeSwap source code directory\033[00m(/CodeSwap/src)\n"
cd CodeSwap/src

echo "\033[01;32mInstalling/Updating bundle\033[00m\n"
bundle install

echo "\033[01;32mSetting-up the database\033[00m\n"
command rake db:migrate
command rake db:reset

echo "\033[01;33mWOOHOO\x21  The system is set-up and ready to go\x21\033[00m\n"
