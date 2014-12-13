---
layout: default
title: 使用 cookie 来持久化登录
---
前面一集，为了保持登陆状态，引入了 session 方法，但是 session 中存储的数据毕竟是临时性的，虽然目前最新的浏览器有各种保持临时数据的缓存方式，但是基本上可以认为如果网站关闭了或是关机重启了，session 中的数据也就丢失了。

那 session 的这个特点就很不适合用在做咱们这一集要实现的功能，remember me 。所以就要介绍一位新朋友 cookie 。跟 session 类似，cookie 的基本知识可以看看这里 <http://happypeter.github.io/tealeaf-http/book/http/3_stateful_web_applications.html>，基本上就是浏览器的一个功能，可以把服务器发过来的数据永久保留成一个我硬盘上的一个文件。另外，Rails 同样提供了一个方法叫 cookies 可以方便开发者操作 cookie 。参考 <http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html>
<!-- mac + chrome 试了一下，即使把浏览器彻底关掉，session[:user_id] 还是有的 -->
<!-- 书上把 cookie 和 session 都叫 method -->




### remember me

添加 checkbox 的代码

到 login.html.erb 中的提交按钮上方，添加

{% highlight erb %}
<dl class="form remember-me">
  <%= check_box_tag :remember_me, 1, params[:remember_me] %>
  <%= label_tag :remember_me %>
</dl>
{% endhighlight %}


user.css.scss 中要追加这些内容

{% highlight sass %}
.remember-me {
  * {
    width: auto;
  }
  #remember_me {
    margin-left: 0;
  }
}
{% endhighlight %}

<!-- http://railscasts.com/episodes/274-remember-me-reset-password
 -->

### cookie

<!-- set a cookie in the code, show peoplw in browser inspector -->
