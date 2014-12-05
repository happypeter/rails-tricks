---
layout: default
title: 用户注册
---

### 添加 /signup

先到 application.html.erb 中添加指向 `/signup` 的链接，然后到 route.rb 中

{% highlight ruby %}
get "signup" => "users#signup", :as => "signup"
{% endhighlight %}

需要跳转到 meetup/ 目录中，执行

    rails g controller users signup
    rails g model user name:string email:string password_digest:string
    rake db:migrate

在到 users_controller.rb 中

{% highlight ruby %}
def signup
  @user = User.new
end
{% endhighlight %}

需要到 route.rb 文件中添加

{% highlight ruby %}
resources :users, only: [:create]
{% endhighlight %}

可以用 `rake route` 命名来查看到底添加了什么样的路由进来。

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

再来添加点样式 app/assets/stylesheets/sections/users.css.scss

{% highlight sass %}
.signup-form-container, .login-form-container{
  width: 670px;
  margin: 50px auto;
  border:1px solid #ddd;
  padding: 2em;
  .signup-form, .login-form {
    width: 100%;
  }
  .signup-button, .login-button {
    padding: 20px;
    width: 100%;
  }
}
{% endhighlight %}

这里停下来，看着这张页面，想想后台要有哪些代码。密码和确认密码项目要匹配，密码存入数据库的时候要加密等等这些任务如果手写是比较麻烦的，好在 Rails 内置了 has_secure_password 这个方法。

### 使用 has_secure_password
<!-- 注册成功了不必直接可以登陆进来，后面慢慢通过实用中的 pain 来引入，包括 session[:return_to] 也是一样 -->

打开 has_secure_password 的[文档](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html)，可以看到要使用它有两个先决条件，第一，要在 Gemfile 里面添加 Bcrypt，第二，就是要求 users 这张表里有 password_digest 这个字段，这个前面咱们已经生成过了。
### 登陆

<!-- 先不考虑报错，什么都不用考虑就是实现基本功能就行 -->

<!-- https://laracasts.com/login 参考这里的样式，和表单验证的报错效果。
 -->

