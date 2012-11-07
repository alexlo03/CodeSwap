#!/bin/bash
cd
sudo apt-get update  # To get the latest package lists
sudo apt-get install curl
curl -L get.rvm.io | bash -s stable
