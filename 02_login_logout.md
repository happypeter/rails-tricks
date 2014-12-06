---
layout: default
title: 登录和退出
---
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
    session[:user_id] = @user.id
    redirect_to :root
  else
    redirect_to :login
  end
end
{% endhighlight %}


### session
这里的 session 是一个特殊的变量...

还需要来到 application_controller.rb

{% highlight ruby %}
def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end
helper_method :current_user
{% endhighlight %}


### 退出登录

<!-- https://laracasts.com/login 参考这里的样式，和表单验证的报错效果。
 -->

