---
layout: default
title: 部署项目
---

密码 digitalocean 已经发送到我的邮箱中了，所以我可以用 root 的身份登人到新加坡的这个服务器之中。
不用 root 来进行部署。


NO.1 创建用户 peter

    adduser peter --ingroup sudo

然后切换到 peter 这个用户

    su peter
    cd

后续所有操作都以 peter 的身份来做。

### 安装 ruby 和 rails


NO.2 安装 ruby 语言

这一部分跟本地开发环境下没有太太的区别，在 [Rails 10日谈课程](http://www.imooc.com/video/4730) 中有一集是专门介绍过的。

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


NO.3 安装 mysql 数据库

      sudo apt-get install mysql-server  mysql-client  libmysqlclient-dev


### 安装服务器

这一步就跟本地开发环境不一样了。

NO.4 安装 nginx 和 passenger

nginx 是一个高速的 web 服务器， passenger 是跑 rails 应用需要的“应用服务器”，总之它们都是服务器。

安装需要的密钥：

<!-- Phusion's PGP key to verify packages -->

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

让 apt-get 支持 https

    sudo apt-get install apt-transport-https ca-certificates
    sudo add-apt-repository 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
    sudo apt-get update

安装 nginx 和 passenger，注意这样安装，就不用执行 `passenger-install-nginx-module` 了，以前的运行这个命令的时候经常
会出现由于内存不够导致执行失败，很烦人的。

    sudo apt-get install nginx-extras passenger


现在浏览器中访问 happypeter.org 就可以看到 nginx 的默认页面了，如果你看不到，证明 nginx 没有装好。

### 部署

NO.4 安装 javascript 的运行环境，这个是跑 rails 应用必须的。

   sudo apt-get install nodejs


NO.5 通过 scp 或者更为常见的用 git clone 命令用 github.com 上把代码 clone 到服务器上。


NO.6 安装 bundler，并用它来把项目需要的依赖包都安装好

    gem install bundler
    rbenv rehash
    cd meetup/
    bundle

NO.7 填写需要的配置

    cd config
    vim database.yml # 填写数据库的密码
    vim ...  # 一般还会有一些其他的配置，不过咱们 meetup 这个项目里就没有了

NO.8 创建数据库

    bundle exec rake db:create db:migrate RAILS_ENV=production

尤其是要注意后面的 `RAILS_ENV` 。


NO.9 把 js/css 等 asset 文件做预处理

    bundle exec rake assets:precompile RAILS_ENV=production
    # precompile 这一句如果不加 RAILS_ENV 设置还是会有问题的，font-awesome 字体文件加载不了

这样的结果是在，public/ 之下出现了很多代哈希值的文件名，粗略的可以认为这样的措施就是为了提高网站访问速度。


NO.10 修改 nginx 和 passenger 配置

打开 nginx 的配置文件：

    sudo vim /etc/nginx/nginx.conf

找到下面的两行，取消注释

    passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
    passenger_ruby /usr/bin/ruby;

并把第二行改为

    passenger_ruby /home/peter/.rbenv/shims/ruby;

然后要来为 meetup 项目，专门创建一个服务器配置文件。

    cd /etc/nginx/sites-enabled
    vim meetup.conf

meetup.conf 中的内容如下

{% highlight nginx %}
server {
  listen 80 default;
  server_name happypeter.org;
  passenger_enabled on;
  gzip on;

  root /home/peter/meetup/public;
}
{% endhighlight %}

nginx 的配置修改后，不要忘了重启 nginx 服务器

    sudo service nginx restart

这样就可以浏览器中访问 happypeter.org 看到应用了。
