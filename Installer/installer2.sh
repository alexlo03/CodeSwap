#!/bin/bash
sudo apt-get update
sudo apt-get install curl
curl -L get.rvm.io | bash -s stable
sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
source ~/.rvm/scripts/rvm
rvm install 1.9.3
rvm use 1.9.3 --default
rvm rubygems current
gem install rails
git clone https://github.com/joyent/node.git
cd node
git checkout v0.6.18
./configure
make
sudo make install
