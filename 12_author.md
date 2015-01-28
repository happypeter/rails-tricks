---
layout: default
title: 权限控制
---


现在的情况是，任何人都可以创建新的 issue 即使是未登录的人也可以，这个显然有问题，所以需要给网站来添加权限管理机制，大的 web 应用中可能
这方面会很复杂，有用户的身份有很多，网站可以执行的操作也可能有很多。不过这一集里，咱们也就算在 authorization 这个角度来开个头，只是区分
最简单的两种用户身份，一种是已经登录用户，另一种是未登录用户，看看如何给他们赋予不同的操作权限。

### 创建新活动按钮


点击首页的发布新活动按钮，如果用户没有登录，则给出一个 flash 来，需要的代码调整是在 issues_controller.rb 中，把原有的 new 动作改成

{% highlight ruby %}
def new
  if not current_user
    flash[:notice] = "没有执行此操作的权限，请先登录"
    redirect_to :root
    return
  else
    @issue = Issue.new
  end
end
{% endhighlight %}



### 隐藏评论框

退出登录条件下再来访问一个活动的展示页面就会报错。这是因为在评论框的代码中用到了 current_user 。解决方法是到
issues/show.html.erb 中

{% highlight erb %}
+ <% if current_user %>
   <%= render partial: 'shared/comment_box', locals: {issue: @issue} %>
+ <% else %>
+   <%= link_to "登录发评论", login_path %>
+ <% end %>
{% endhighlight %}


### 只有 issue 发布者自己可以修改

需要用到 `@issue.user` 所以先要来添加这两个资源的一对多关系。

    rails g migration AddUserIdToIssues user_id:integer
    bundle exec rake db:migrate

issues_controller.rb 中调整一下

{% highlight ruby %}
def issue_params
-  params.require(:issue).permit(:title, :content)
+  params.require(:issue).permit(:title, :content, :user_id)
end
{% endhighlight %}

user.rb 中添加

{% highlight ruby %}
has_many :issues
{% endhighlight %}

issue.rb 中添加

{% highlight ruby %}
belongs_to :user
{% endhighlight %}



现在的问题 issue#new 和 #edit 中目前是复用的一个 partial，但是现在 new 中需要把 user_id 作为 hidden_field 传递过去，所以把 _form.html.erb 中
的内容拷贝到 issues/new.html.erb 中，然后做如下调整

{% highlight erb %}
-     <%= form_for issue do |f| %>
+     <%= form_for(Issue.new(user_id: current_user.id)) do |f| %>
+      <%= f.hidden_field :user_id %>
{% endhighlight %}

原先创建的 issue 肯定是没有 user_id 的，所以都删除了，重新创建。

    rails c
    Issue.destroy_all

这样新创建的 issue 就可以打开了，但是头像和用户名现在还都是 happypeter，这个也不对，要调整一下

_issue_list.html.erb 中

{% highlight erb %}
-      <a href="/happypeter">
-        <img src=http://gravatar.com/avatar/a92785d8d68f1d1d83b008574f8b5dba.png?s=512&amp;d=retro alt="">
-      </a>

+      <%= link_to "#" do %>
+        <%= image_tag i.user.avatar %>
+      <% end %>

-      <a href="/happypeter">happypeter</a>
+      <%= link_to i.user.name, '#' %>
{% endhighlight %}

issues/show.html.erb 中也是一样的

{% highlight erb %}
-  <img src="http://gravatar.com/avatar/a92785d8d68f1d1d83b008574f8b5dba.png?s=512&amp;d=retr" alt="" class="image-circle">
+  <%= image_tag @issue.user.avatar, class: "image-circle" %>
-  <h5 class="name"><a href="#">happypeter</a></h5>
+  <h5 class="name"><%= link_to @issue.user.name, "#" %></h5>
{% endhighlight %}

更多关于权限控制的技巧，可以查看 railscasts.com 的 [authorization 标签](http://railscasts.com/?tag_id=26)。
