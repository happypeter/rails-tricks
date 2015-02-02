---
layout: default
title: 邮件发送
---

网站上线后，朋友们就会来注册，所以一个靠谱的做法是每当网站有了更新就及时发个邮件通知各位高朋。

### 使用 ActionMailer
参考资料是 [Action Mailer Guide](http://guides.rubyonrails.org/action_mailer_basics.html)

这一集里咱们就拿一个最简单的情况做例子，有新用户注册了，那就给他发一封邮件表示欢迎。

顺着一个比较直白的思路来写这些代码。先到 users_controller.rb 中

{% highlight ruby %}
if @user.save
+ UserMailer.welcome_email(@user).deliver
  cookies[:auth_token] = @user.auth_token
{% endhighlight %}

这样问题来了，没有 UserMailer 也没有 welcome_email 这个方法。所以要执行

    rails generate mailer UserMailer


把生成的 user_mailer.rb 稍微做一下修改，改成下面这样

{% highlight ruby %}
class UserMailer < ActionMailer::Base
  default from: "hello@happypeter.org"
   def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome')
  end
end
{% endhighlight %}

这个就跟一个 controller action 差不多，所以还要添加一个 view 文件进来，也就是邮件正文了。

真正的邮件要放在 app/views/user_mailer/welcome_email.html.erb

### 漂亮的 email
白纸黑字的 email 看起来不够可爱，email 因为是在邮箱中打开的，所以写 css 和 html 的时候跟普通网页还是有些区别的，比如网页开发中目前已经基本淘汰的
table，在 email 这里却是要经常用到的。google 一下 ”tuts html mail” 可以在 tutsplus 的网站上找到一些很好的教程。不过最简单的方式还是直接根据别人
的模板来改一下。我这里就可以直接拷贝我自己 happycasts 这个项目中的 [code](https://github.com/happypeter/happycasts/blob/master/app/views/happy_mailer/new_ep_release.html.erb) 。


现在咱们的邮件发送功能基本上实现了，除了发不出去邮件之外，没有什么缺陷:-)

### 配置 Mailgun
mailgun 这边不用填信用卡就可以发送免费的每月10000封邮件。

创建一个新的 domain，叫做 `happypeter.org`

production.rb 中

{% highlight ruby %}
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :authentication => :plain,
  :address => "smtp.mailgun.org",
  :port => 587,
  :domain => "happypeter.org",
  :user_name => "postmaster@happypeter.org",
  :password => "4ad82cc1a130a90b0f2c6a03eff7bd35"
}
{% endhighlight %}

实际中这些用户名密码信息一般不会写到 production.rb 中，可以考虑设置环境变量或者使用 [Settingslogic](https://github.com/settingslogic/settingslogic) 。
