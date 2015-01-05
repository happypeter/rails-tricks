---
layout: default
title: 评论功能重构
---


先来创建一个新的活动。

这样新活动的时间有问题，显示 ` translation missing: zh-CN.datetime.distance_in_words.less_than_x_minutes ago`

可以到 [rails-i18n](https://github.com/svenfuchs/rails-i18n) 项目的页面，敲 `t` 然后输入 `zh-C...` 就可以找到中文本地化文件了，把 `datetime` 部分拷贝到项目中。然后用 sublime 的 `find in folder` 的功能，把 `ago`
替换成“前”，这样时间显示就正常了。

### 评论框

现在有了用户登录进来了，所以评论框这里根本也不需要输入用户名和邮箱了，来看看这部分应该怎么重构。
首先考虑数据表结构，现在有了专门的 users 表来存放用户信息，那么原来存放在 comments 表记录中的

    t.string   "username"
    t.string   "email"

就不需要了，而只需要添加 user_id 到每一条 comment 记录中就可以了。

生成一个 migration 文件，运行

    rails g migration ChangeThingsInComments

打开生成的文件，里面填写如下内容

{% highlight ruby %}
class ChangeThingsInComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :string
    remove_column :comments, :username
    remove_column :comments, :email
  end
end
{% endhighlight %}


运行 `bundle exec rake db:migrate`，然后再来查看 schema.rb 文件就可以看到 comments 表结构已经修改成功。
