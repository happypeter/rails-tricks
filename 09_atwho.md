---
layout: default
title: 评论提交快捷键和 atwho
---

在 github issue 这里发评论，有两个功能其实是挺诱人的。第一个就是如果敲 `@`，后面可以自动补全参与讨论的用户名。第二个
我觉得每天也实在离不了的功能是，发评论的时候，我不用再去找鼠标点发布按钮，而是可以顺手一个 Cmd+Enter 就搞定了。这里，
咱俩也来做做这两个小而美的功能。


### Atwho

需要用到 [jquery-atwho-rails gem](https://github.com/ichord/jquery-atwho-rails) 。

Gemfile 中添加 `gem 'jquery-atwho-rails'`，不要忘记运行 bundle 命令来安装。

application.js 中来添加 `//= require jquery.atwho` 当然是应该在 jquery 加载之后的位置。

如果你发现 css 看起来很乱，那一定是忘了在 application.css 中添加 ` *= require jquery.atwho` 。

issues/show.html.erb 的末尾添加

{% highlight js %}
<script>
  var commenter_exist = [];
  $('.reply .heading a').each(function() {
    if($.inArray($(this).text(), commenter_exist) < 0) {
      commenter_exist.push($(this).text());
    }
  });
  $('textarea').atwho({ at: "@", 'data': commenter_exist });
</script>
{% endhighlight %}


### 快捷键

[jquery.hotkeys](https://github.com/jeresig/jquery.hotkeys) 是一个 js 库，[相应的 gem](https://github.com/derekprior/jquery-hotkeys-rails) 有一年多没更新了，所以还是直接把 js 添加进源码吧。

下载 [这个文件](https://raw.githubusercontent.com/jeresig/jquery.hotkeys/master/jquery.hotkeys.js) 放到 app/assets/javascript/vendor/ 目录下，然后在 application.js 中添加 `//= require vendor/jquery.hotkeys` (同样是要放在 `require jquery` 之后 ) 。
