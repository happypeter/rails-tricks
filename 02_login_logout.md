---
layout: default
title: 登录和退出
---

这一集讲登录和退出登录，会涉及到一个重要的概念 session ，中文翻译叫“会话”。官方的 session 基本使用的文档 <http://guides.rubyonrails.org/action_controller_overview.html#accessing-the-session> 。

### 登陆
现在看看如何用这个账户来登陆。

application.html.erb 中来添加

{% highlight erb %}
<%= link_to "login", login_path %>
{% endhighlight %}

route.rb 中对应要有

{% highlight ruby %}
get "login" => "users#login", :as => "login"
{% endhighlight %}

users_controller.rb 中

{% highlight ruby %}
def login
end
{% endhighlight %}

当然也可以不写。添加模板，app/views/users/login.html.erb

{% highlight erb %}
<div class="login-form-container clearfix">
  <div class="login-form">
    <%= form_tag "/create_login_session" do %>
      <dl class="form">
        <dt>
          <%= label_tag "用户名" %>
        </dt>
        <dd>
          <%= text_field_tag :name, params[:name] %>
        </dd>
      </dl>
      <dl class="form">
        <dt>
          <%= label_tag "密码" %>
        </dt>
        <dd>
          <%= password_field_tag :password, params[:password] %>
        </dd>
      </dl>
      <p> <%= submit_tag "登录", :class => "login-button btn btn-primary" %> </p>
      <div class="need-signup">
        <%= link_to "没有账号？注册一个吧", signup_path %>
      </div>
    <% end %>
  </div>
</div>
{% endhighlight %}

表单中把数据提交到 `"/create_login_session"` 这个路由，所以要到 route.rb 中

{% highlight ruby %}
post "create_login_session" => "users#create_login_session"
{% endhighlight %}

这样真正的工作就要在 users_controller.rb 中开展了

{% highlight ruby %}
def create_login_session
  user = User.find_by_name(params[:name])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to :root
  else
    redirect_to :login
  end
end
{% endhighlight %}


### session 和 current_user
这里的 session 中文翻译成“会话”，在 Rails 中是一个默认就有的方法，你可以向里面存放数据，那么只要你一直打开网站，那么你存储的数据就一直存在。
session 的底层实现原理，参考： <http://happypeter.github.io/tealeaf-http/book/http/3_stateful_web_applications.html>

和 session 密切相关的一个概念是 cookie，下一集来介绍。

到 application_controller.rb

{% highlight ruby %}
def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end
helper_method :current_user
{% endhighlight %}

application.html.erb 中

{% highlight erb %}
<% if current_user %>
  <li><%= link_to current_user.name, "#" %></li>
  <li><%= link_to "logout", "#" %></li>
<% else %>
  <li><%= link_to "login", login_path %></li>
  <li><%= link_to "signup", signup_path %></li>
<% end %>
{% endhighlight %}

上面，当前用户的用户名应该链接到用户的个人页面，这里咱们先不弄。

### 退出登录
application.html.erb 中 logout 对应的这一行改为

{% highlight erb %}
<li><%= link_to "logout", logout_path, method: "delete" %></li>
{% endhighlight %}

route.rb 中

{% highlight ruby %}
delete "logout" => "users#logout", :as => "logout"
{% endhighlight %}

users_controller.rb 中

{% highlight ruby %}
def logout
  session[:user_id] = nil
  redirect_to :root
end
{% endhighlight %}

这样就可以退出登录了。


