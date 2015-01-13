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

Install Phusion's PGP key to verify packages

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

Add HTTPS support to APT

    sudo apt-get install apt-transport-https ca-certificates
    sudo add-apt-repository 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
    sudo apt-get update
    sudo apt-get install nginx-extras passenger


<!-- 51 haoqicat/ 214 happycasts 服务器上目前就就是安装了 nginx -->
