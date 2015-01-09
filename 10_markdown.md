---
layout: default
title:  Markdown 格式化内容
---

开发过程就是不断解决实际使用中的痛苦的过程。来看看评论的功能，如果发布的内容我想加一个空行，但是实际输出还是会在一段之中。所以来看看咱们添加 Markdown 格式的支持。


### 使用 Redcarpet

首先在 Gemfile 中添加

{% highlight ruby %}
gem 'redcarpet'
{% endhighlight %}

再到 _comment.html.erb 中来使用一下

{% highlight ruby %}
- <%= c.content %>
+ <%= Redcarpet.new(c.content).to_html %>
{% endhighlight %}
