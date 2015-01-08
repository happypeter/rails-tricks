---
layout: default
title: 评论提交 hotkeys 和 atwho
---

在 github issue 这里发评论，有两个功能其实是挺诱人的。第一个就是如果敲 `@`，后面可以自动补全参与讨论的用户名。第二个
我觉得每天也实在离不了的功能是，发评论的时候，我不用再去找鼠标点发布按钮，而是可以顺手一个 Cmd+Enter 就搞定了。这里，
咱俩也来做做这两个小而美的功能。

### Css Fix

不过，先来看看这个评论框，输入框和按钮总会出现蓝边，这个不太好看。有经验的前端会一眼看出问题所在。现在假设
咱们不知道发生了什么，看看如何来自己定位这个问题。

首先来看到底是哪个状态下会出现蓝边呢？打开 devtools，选中这个 element，点击右侧的小箭头，试一下。发现是 `:focus`
这个状态的时候会有蓝边。对应的 css 是浏览器默认的 `outline:xxx` 。

这样，解决方法就简单了，就是到 common.css.scss 中的 form 样式的花括号内部，添加

{% highlight scss %}
form {
  ...
  * {
    &:focus {
      outline: none;
    }
  }
  ...
}
{% endhighlight %}

### Atwho

需要用到 [jquery-atwho-rails gem](https://github.com/ichord/jquery-atwho-rails) 。

Gemfile 中添加

{% highlight ruby %}
gem 'jquery-atwho-rails'
{% endhighlight %}

不要忘记运行 bundle 命令来安装。

application.js 中来添加

{% highlight js %}
//= require jquery.atwho
{% endhighlight %}

当然是应该在 jquery 加载之后的位置。

如果你发现 css 看起来很乱，那一定是忘了在 application.css 中添加

{% highlight css %}
*= require jquery.atwho`
{% endhighlight %}

关键的一步，到 issues/show.html.erb 的末尾添加

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

下载 [这个文件](https://raw.githubusercontent.com/jeresig/jquery.hotkeys/master/jquery.hotkeys.js) 放到 app/assets/javascript/vendor/ 目录下，然后在 application.js 中添加

{% highlight js %}
//= require vendor/jquery.hotkeys`
{% endhighlight %}

同样是要放在 `require jquery` 之后  。

到 _comment_box.html.erb 的末尾添加

{% highlight js %}
<script>
  $(".reply textarea#comment_content").keydown(function(e) {
    if ((e.ctrlKey||e.metaKey) && e.keyCode == 13) {
      $(".reply input[type=submit]").click();
    }
  });
</script>
{% endhighlight %}

`13` 对应回车键，`ctrKey` 对应 ctrl，`metaKey` 在 Mac 下对应 Command 键， Windows 下应该对应 Window 键。
到 [源码](https://github.com/jeresig/jquery.hotkeys/blob/master/jquery.hotkeys.js) 中可以看到更多的键值。
