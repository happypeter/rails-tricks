---
layout: default
title: 部署项目
---

### 创建用户

adduser peter --ingroup sudo

### 安装 nginx

Install Phusion's PGP key to verify packages

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

Add HTTPS support to APT

sudo apt-get install apt-transport-https ca-certificates


sudo add-apt-repository 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
sudo apt-get update

sudo apt-get install nginx-extras passenger

<!-- 51 haoqicat/ 214 happycasts 服务器上目前就就是安装了 nginx -->
