---
layout: default
title: 部署项目
---

### 创建用户

    adduser peter --ingroup sudo

### 安装 ruby

    sudo apt-get update
    sudo apt-get install git-core curl zlib1g-dev build-essential \
                         libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                         libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common

    cd
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec $SHELL

    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    exec $SHELL

    rbenv install 2.1.2
    rbenv global 2.1.2


install mysql

      sudo apt-get install mysql-server  mysql-client  libmysqlclient-dev


### 安装 nginx

安装需要的密钥：

<!-- Phusion's PGP key to verify packages -->

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7


让 apt-get 支持 https

    sudo apt-get install apt-transport-https ca-certificates
    sudo add-apt-repository 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
    sudo apt-get update

安装 nginx 和 passenger，注意这样安装，就不用执行 `passenger-install-nginx-module` 了

    sudo apt-get install nginx-extras passenger


   gem install bundler
   rbenv rehash

   sudo apt-get install nodejs




### 部署

clone 代码之前需要先把 ssh key 上传到 github 网站上，不然没有办法 clone

    cd meetup/
    bundle

    cd config
    cp database.example.yml database.yml
    bundle exec rake db:create db:migrate RAILS_ENV=production
    touch tmp/restart.txt

    bundle exec rake assets:precompile RAILS_ENV=production
    # precompile 这一句如果不加 RAILS_ENV 设置还是会有问题的，font-awesome 字体文件加载不了


### 导入老数据

mysql -uroot -p111111 happycasts_production<happycasts_production.sql
ERROR 1064 (42000) at line 379: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''20' at line 1
