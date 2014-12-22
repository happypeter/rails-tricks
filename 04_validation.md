---
layout: default
title: 表单验证
---
<!-- https://laracasts.com/login 参考这里的样式，和表单验证的报错效果。
 -->

 本视频介绍 form validation，表单验证。也就是在用户填写注册表单的时候
 如果填写的内容有明显的问题，程序能够检查，并且报错，避免直接把有问题的内容
 直接存入数据库。

 <!-- 登陆的时候，信息填写如果有错误，当然也应该能够看到报错信息。
  不过就不用表单验证了，直接给个 flash 就好了
  -->


 ```ruby
 validates :name, :email, presence: true
 validates :name, :email, uniqueness: { case_sensitive: false }
 ```

注意由于 password 部分的验证，has_secure_password 中已经定义过了，所以这里就不用写了

进入 rails c 执行

    u = User.new
    u.save
    u.errors.messages

这样就知道有哪些报错信息可以用来在 view 文件中使用了。

也有些方法在呼叫的时候是会跳过表单验证的，<http://guides.rubyonrails.org/active_record_validations.html> 的 1.3 部分有明确的列出。


users#create 方法中要用实例变量，同时最后不能用 redirect_to 而要用 render

signup.html.erb

```erb
<% if @user.errors[:name].any? %>
<dd class="error"><%= @user.errors[:name][0] %></dd>
<% end %>
```

<!-- 到这里就可以显示英文的报错信息了，如果覆盖默认的信息呢？ 下一集介绍-->

common.css.scss 中 form 大括号里面添加

```scss
.error {
  margin: 5px 0 9px 0;
  color: #DB8A14;
}
```

 自定义 validator 参考 [这里]（http://guides.rubyonrails.org/active_record_validations.html）
 的第6部分： Performing Custom Validations 。
