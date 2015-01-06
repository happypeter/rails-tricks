---
layout: default
title: 评论功能重构
---

这一集里来重构评论功能，为了能发评论，首先要有一个新活动。

来创建一个新的活动。 Oops...新活动的时间有问题，显示

    translation missing: zh-CN.datetime.distance_in_words.less_than_x_minutes ago

可以这样来解决。到 [rails-i18n](https://github.com/svenfuchs/rails-i18n) 项目的页面，敲 `t` 然后输入 `zh-C...` 就可以找到中文本地化文件了，把 `datetime` 部分拷贝到项目中。然后用 sublime 的 `find in folder` 的功能，把 `ago`
替换成 `前` ，这样时间显示就正常了。

下面言归正传，来瞄准评论功能。

### 重构数据表 comments

现在有了用户登录进来了，所以评论框这里不需要输入用户名和邮箱了，来看看这部分应该怎么重构。
首先考虑数据表结构，现在有了专门的 users 表来存放用户信息，那么原来存放在 comments 表，
查看 schema.rb，中的

    t.string   "username"
    t.string   "email"

就不需要了，而只需要添加 user_id 到每一条 comment 记录中就可以了。

生成一个 migration 文件，运行

    rails g migration ChangeThingsInComments

打开生成的文件，里面填写如下内容

{% highlight ruby %}
class ChangeThingsInComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer
    remove_column :comments, :username
    remove_column :comments, :email
  end
end
{% endhighlight %}

注：上面的语法也不唯一，可以参考 [Miagration 的文档](http://guides.rubyonrails.org/active_record_migrations.html) 。

运行 `bundle exec rake db:migrate`，然后再来查看 schema.rb 文件就可以看到 comments 表结构已经修改成功。

comments 表中有了 user_id 这个字段，就可以在 users 和 comments 表之间建立一对多关系了。需要做的是
到 user.rb 中添加

{% highlight ruby %}
has_many :comments
{% endhighlight %}

然后到 comment.rb 中添加

{% highlight ruby %}
belongs_to :user
{% endhighlight %}

这样就可以使用 `@comment.user.name` 这样的语法了。

### 更改 form

user.rb 中要添加

{% highlight ruby %}
def avatar
  gravatar_id = Digest::MD5.hexdigest(self.email.downcase) if self.email
  "http://gravatar.com/avatar/#{gravatar_id}.png?s=512&d=retro"
end
{% endhighlight %}

这样 comment.rb 中的这些代码就可以删除了

{% highlight ruby %}
def user_avatar
  gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
  "http://gravatar.com/avatar/#{gravatar_id}.png?s=512&d=retro"
end
{% endhighlight %}

route.rb 中需要

{% highlight ruby %}
resources :comments, only: [:create]
{% endhighlight %}


`_comment_box.html.erb` 中原来那个表单不要了，改成

{% highlight erb %}
<%= form_for(Comment.new(:issue_id => issue.id, :user_id => current_user.id)) do |f| %>
  <%= f.hidden_field :issue_id %>
  <%= f.hidden_field :user_id  %>
  <%= f.text_area :content %>
  <%= submit_tag '提交评论', class: 'btn btn-primary btn-submit' %>
<% end %>
{% endhighlight %}

头像部分也要稍作调整

{% highlight erb %}
-      <%= image_tag "default_avatar.png", class: "image-circle" %>
+      <img src=<%= current_user.avatar %> alt="" class="image-circle">
{% endhighlight %}

comments_controller.rb 中，把原有内容改为下面内容：

{% highlight ruby %}
def create
  c = Comment.new(comment_params)
  c.save
  redirect_to c.issue
end

private
  def comment_params
    params.require(:comment).permit(:issue_id, :user_id, :content)
  end
{% endhighlight %}

这样评论就可以成功提交了。直接在 `Comment.new` 中使用 `params[:comment]` 会触发 Rails 的 Strong Parameters 的
保护机制。通过下面定义 `comment_params` 的方式，Rails 让我自己手动列出允许存入的数据的白名单，这样就避免了危险。

### 更改评论列表

_comment_list.html.erb 中也要做调整

{% highlight erb %}
- <%= image_tag c.user_avatar, class: 'image-circle' %>
+ <%= image_tag c.user.avatar, class: 'image-circle' %>
...
- <h5 class="name"><%= link_to c.username, "#" %></h5>
+ <h5 class="name"><%= link_to c.user.name, "#" %></h5>
{% endhighlight %}
