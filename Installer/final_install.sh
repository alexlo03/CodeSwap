#!/bin/bash
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
