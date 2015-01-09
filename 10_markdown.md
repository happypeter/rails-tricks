---
layout: default
title:  Markdown 格式化内容
---

开发过程就是不断解决实际使用中的痛苦的过程。来看看评论的功能，如果发布的内容我想加一个空行，但是实际输出还是会在一段之中。所以来添加 [Markdown](https://help.github.com/articles/github-flavored-markdown/) 格式的支持。


### 使用 Redcarpet

首先在 Gemfile 中添加 [redcarpet](https://github.com/vmg/redcarpet)

{% highlight ruby %}
gem 'redcarpet'
{% endhighlight %}

bundle 一下，可以看到 Gemfile 中安装的版本是 3.2.0 。未来如果版本有了大的变化，那么下面使用的接口可能也会边，以 [官方 README](https://github.com/vmg/redcarpet) 为准。

再到 _comment.html.erb 中来使用一下

{% highlight erb %}
- <%= c.content %>
+ <%= markdown(c.content) %>
{% endhighlight %}

issues/show.html.erb 中的活动内容也做相同对待

{% highlight erb %}
- <%= @issue.content %>
- <%= markdown(@issue.content) %>
{% endhighlight %}

需要到 application_helper.html.erb 中来定义 markdown

{% highlight ruby %}
def markdown(text)
  renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
  options = {
    autolink: true,
    no_intra_emphasis: true,
    fenced_code_blocks: true,
    lax_html_blocks: true,
    strikethrough: true,
    superscript: true
  }
  Redcarpet::Markdown.new(renderer, options).render(text).html_safe
end
{% endhighlight %}

这些都是安照，[官方 README](https://github.com/vmg/redcarpet) 来写的。具体每个参数的意义都可以在页面上找到。

说说上面的 `html_safe` 的作用，如果去掉，页面中刷新会出现 html 标签，这是一种安全机制，防止有人嵌入 html 代码来实现对网站的攻击。不过前面 `filter_html: true` 已经过滤掉了可能导致安全隐患的 html 标签。所以就可以放心的来添加 `.html_safe` 来让 Rails 放弃这种安全机制了。


### 用 pygment 实现代码高亮

Gemfile 中添加 [pygemnt.rb](https://github.com/tmm1/pygments.rb)

{% highlight ruby %}
gem 'pygment.rb'
{% endhighlight %}

<!-- 这样系统上就不用安装 pygment 了，所有的 py 代码都打包到 Gem 中了 -->

到 application_helper.rb 中添加

{% highlight ruby %}

class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    Pygments.highlight(code, lexer: language)
  end
end

def markdown(text)
- renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
+ renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
  ...
end
{% endhighlight %}


### 添加 css

创建一个新文  app/assets/stylesheets/shared/pygment.css.erb

{% highlight erb %}
<%= Pygments.css(:style => "monokai") %>
{% endhighlight %}

接下来，需要调整一下评论框的 css 来让整个显示的漂亮一点，参考 [laracasts forum](https://laracasts.com/discuss/channels/general-discussion/laravel-5-password-reset-subject)

issue_show.css.scss 中

{% highlight scss %}
.body {
- padding: 15px;
+ padding: 15px 40px 10px 40px;
  .highlight {
    margin-top: 15px;
    background: #2D3037;
    padding: 5px 40px;
    margin-left: -40px;
    margin-right: -40px;
    pre {
      margin-top: 9px;
    }
  }
  textarea {
    border: none;
    height: 230px;
    margin-top: -20px;
  }
}
{% endhighlight %}


这样就可以了。
