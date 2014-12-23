---
layout: default
title: 表单验证
---

 本视频介绍 form validation，表单验证。也就是在用户填写注册表单的时候
 如果填写的内容有问题，程序能够检查并且报错，避免直接把有问题的内容
 直接存入数据库。

### Rails 自带的 validator 接口

<http://guides.rubyonrails.org/active_record_validations.html> 上又各种接口的说明，
应该说最常用的情况都有现成的 validator 可以用。

关键的一步是到 user.rb 中添加

 ```ruby
 validates :name, :email, presence: true
 validates :name, :email, uniqueness: { case_sensitive: false }
 ```

注意由于 password 部分的验证，`has_secure_password` 中已经定义过了，所以这里就不用写了。

进入 rails c 执行

    u = User.new
    u.save
    u.errors.messages

这样就知道有哪些报错信息可以用来在 view 文件中使用了。

也有些方法在呼叫的时候是会跳过表单验证的，<http://guides.rubyonrails.org/active_record_validations.html> 的 1.3 部分有明确的列出。

### controller 和 view 文件中相应的调整


users_controller.rb 中的 create 方法需要调整，要用实例变量，同时最后不能用 redirect_to 而要用 render

```ruby
-    user = User.new(user_params)
-    user.save
-    cookies[:auth_token] = user.auth_token
-    redirect_to :root
+    @user = User.new(user_params)
+    if @user.save
+      cookies[:auth_token] = user.auth_token
+      redirect_to :root
+    else
+      render :signup
+    end
```

这样就可以在 signup.html.erb 中适当显示报错信息了，每个 input 的下方都添加类似于下面的内容

```erb
<% if @user.errors[:name].any? %>
<dd class="error"><%= @user.errors[:name][0] %></dd>
<% end %>
```

其中 `:name` 字样会相应变成 `:email` ，`:password` ，`:password_confirmation`


common.css.scss 中 form 大括号里面添加

```scss
.error {
  margin: 5px 0 9px 0;
  color: #DB8A14;
}
```

这样就可以显示英文的报错信息了，如何显示中文，下一集介绍。

### 自定义 validator
参考 [这里](http://guides.rubyonrails.org/active_record_validations.html)
 的第6部分： Performing Custom Validations 。
