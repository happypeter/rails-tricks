---
layout: default
title: 使用 cookie 来持久化登录
---

### cookie 和 session
<!-- 书上把 cookie 和 session 都叫 method -->
我在代码中写 `cookies[:user_name] = "david"` 那当我的浏览器关闭了，这个数据也就丢失了。
<!-- mac + chrome 试了一下，即使把浏览器彻底关掉，session[:user_id] 还是有的 -->

但是如果写成 `cookies.permanent[:user_name] = "david"` 这样写过期时间是 20 年。
 `cookies` 中的数据会存放到到我的浏览器的 cookie 里，也就是保存到了我的硬盘上了，这就是为啥即使关机重启，这个信息也是可以保留住。

 更多 `cookies` 这个方法的使用，参考 <http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html>

 <!-- set a cookie in the code, show peoplw in browser inspector -->

 关于 http cookie 到底是什么？参考 <http://happypeter.github.io/tealeaf-http/book/http/3_stateful_web_applications.html>
 关于 Rails 中的 cookie 方法的具体讲解 <http://guides.rubyonrails.org/action_controller_overview.html>

### remember me
http://railscasts.com/episodes/274-remember-me-reset-password

