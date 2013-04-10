#!/bin/bash
rvmsudo screen -S server_basic  rails s -p 80
sudo screen -S secureserver -d -m bundle exec ruby secure_rails s -p 443

