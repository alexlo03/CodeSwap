#!/bin/bash
#Acquire dependencies for rvm
sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

#Install and run rvm
source ~/.rvm/scripts/rvm

type rvm | head -n 1

rvm autolibs enable
rvm requirements
#Use rvm to install ruby version 1.9.3
rvm install 1.9.3

#Make rvm use 1.9.3 as the default version
rvm use 1.9.3 --default

rvm requirements
#Update rubygems with rvm
rvm rubygems current

#Install ruby on rails
gem install rails
