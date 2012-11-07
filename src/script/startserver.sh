sudo screen -S server -d -m rails s -p 80

sudo screen -S secureserver -d -m bundle exec ruby secure_rails s -p 443  