cd
#!/bin/sh
sudo apt-get update  # To get the latest package lists
sudo apt-get install curl
curl -L get.rvm.io | bash -s stable

#Install and run rvm
source ~/.rvm/scripts/rvm

#Acquire dependencies for rvm
sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
#Use rvm to install ruby version 1.9.3
rvm install 1.9.3

#Make rvm use 1.9.3 as the default version
rvm use 1.9.3 --default

#Update rubygems with rvm
rvm rubygems current

#Install ruby on rails
gem install rails

#Download node.js and install
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

#Move into CodeSwap Directory
cd CodeSwap

#Move into src Directory
cd src

#installs/ updates bundle
bundle install

#set up the database
rake db:migrate

# Start the server!
rails server
