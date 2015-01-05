---
layout: default
title: flash
---

这次来显示 Login 失败信息。采用 flash 来实现，中文意思是“闪一下”。参考 [这里](http://guides.rubyonrails.org/action_controller_overview.html) 的 5.2 部分。

<!--  给出真正美观实用的 css 和 js 效果 -->

### flash 和 session 这两个方法的区别

`session[:xxx]` 中存储的数据会一直保留，直到你把网站关闭。而 `flash[:xxx]` 中存放的数据只是在
你下一次请求中可以取得，然后就自动被清空了。

实际操作来看一下。

到 users_controller.rb 的 `create_login_session` 方法中，这里提一句，controller 里的一个方法，
通常都对应一次请求动作，所以 rails 下通常英文叫做 action 。这里咱们给登陆成功和失败两种情况，都给出一定
的反馈信息。

{% highlight ruby %}
+ flash.notice = "登陆成功！"
  redirect_to :root
else
+ flash.notice = "用户名密码错误!"
  redirect_to :login
end
{% endhighlight %}

通过 flash 就可以把当前 action 中的信息传送给下一个 action 了。

到 application.html.erb 中添加

{% highlight erb %}
<% if flash.notice %>
  <div class="notice"><%= flash.notice %></div>
<% end %>
{% endhighlight %}

这样，当登陆失败，页面重定向到 login 页面的时候，就可以显示信息了。但是点击任意链接到其他的页面中，
flash 就被清空了，所以也就看不到信息了，这正是咱们期待的效果。但是如果用 session 接口，就完蛋了。

### flash.now

每次咱们用 redirect_to ，这样浏览器是会发出一个全新的请求，那么 flash 中的信息正好就可以在下一次请求中用到。
但是，如果使用 render 来生成页面，这样就没有新的请求了，那么能不能显示 flash 信息呢？可以，用 `flash.now` 就行。

例如在 users_controller.rb 的 create 方法中

{% highlight ruby %}
def create
...
  else
+   flash.now.notice = "信息填写的有问题"
    render :signup
  end
end
{% endhighlight %}

参考 [这里](http://guides.rubyonrails.org/action_controller_overview.html) 的 5.2.1 部分。


### 美化一下

生成阴影代码，可以使用这个 [小工具](http://www.cssmatic.com/box-shadow) 。

最终可以在 common.css.scss 中添加：

{% highlight css %}
#notice {
  position: absolute;
  bottom: 20px;
  right: 20px;
  background: teal;
  color: white;
  padding: 20px;
  -webkit-box-shadow: 6px 7px 9px -1px rgba(0,0,0,0.68);
  -moz-box-shadow: 6px 7px 9px -1px rgba(0,0,0,0.68);
  box-shadow: 6px 7px 9px -1px rgba(0,0,0,0.68);
}
{% endhighlight %}

下面来实现 flash 信息的自动消失。到 application.html.erb 中 `</body>` 的上面，添加

{% highlight js %}
<script>
  $('.home-banner').anystretch();
+ var hideNotice = function(){
+     $(".notice").fadeOut("slow");
+ }
+ setTimeout(hideNotice, 4000);
</script>
{% endhighlight %}

这样四秒钟后信息就自动消失了。
<!-- 这里 `$('.home-banner').anystretch();` 只是在首页才会用到，可以用 content_for 重构一下
不过分页加载内容其实是挺麻烦的，所以如果不影响性能的话，还是不用为上策
-->
