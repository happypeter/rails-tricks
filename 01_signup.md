---
layout: default
title: 用户注册
---

### 添加 /signup

先到 application.html.erb 中添加指向 `/signup` 的链接，然后到 route.rb 中

{% highlight ruby %}
get "signup" => "users#signup", :as => "signup"
{% endhighlight %}

在到 users_controller.rb 中

{% highlight ruby %}
def signup
  @user = User.new
end
{% endhighlight %}

对应的 app/views/users/signup.html.erb

{% highlight erb %}
<div class="signup-form-container clearfix">
  <div class="signup-form">
    <%= form_for @user do |f| %>
        <dl class="form">
          <dt><%= f.label :name, "用户名" %></dt>
          <dd><%= f.text_field :name %></dd>
        </dl>
        <dl class="form">
          <dt> <%= f.label :email %></dt>
          <dd> <%= f.text_field :email %> </dd>
        </dl>
        <dl class="form">
          <dt> <%= f.label :password, "密码" %> </dt>
          <dd> <%= f.password_field :password %> </dd>
        </dl>
        <dl class="form">
          <dt> <%= f.label :password_confirmation, "请再输入一次" %> </dt>
          <dd> <%= f.password_field :password_confirmation %> </dd>
        </dl>
        <p><%= f.submit "注册", :class => "signup-button btn btn-primary" %></p>
    <% end %>
  </div>
</div>
{% endhighlight %}


这里停下来，看着这张页面，想想后台要有哪些代码。密码和确认密码项目要匹配，密码存入数据库的时候要加密等等这些任务如果手写是比较麻烦的，好在 Rails 内置了 has_secure_password 这个方法。
### 使用 has_secure_password

<!-- 注册成功了不必直接可以登陆进来，后面慢慢通过实用中的 pain 来引入，包括 session[:return_to] 也是一样 -->

### 登陆

<!-- 先不考虑报错，什么都不用考虑就是实现基本功能就行 -->

<!-- https://laracasts.com/login 参考这里的样式，和表单验证的报错效果。
 -->

