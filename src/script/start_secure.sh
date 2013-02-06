#!/bin/bash
rvmsudo screen -d -m -S server_basic rails s -p 80
rvmsudo screen -d -m -S server_secure bundle exec ruby secure_rails s -p 443
rvmsudo screen -d -m -S emailer rake jobs:work
