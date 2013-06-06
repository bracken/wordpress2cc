module Wordpress2CC
  class Post
    include HappyMapper

    tag 'item'
    element :title, String, :tag => 'title'
    element :pud_date, String, :tag => 'pubDate'
    element :content, String, :tag => 'content:encoded'
    element :post_id, String, :tag => 'wp:post_id'
    element :status, String, :tag => 'wp:status'
    element :post_parent, String, :tag => 'wp:post_parent'
    element :post_type, String, :tag => 'wp:post_type'
    element :post_name, String, :tag => 'wp:post_name'
    has_many :categories, Wordpress2CC::Category
    attr_accessor :tags

    after_parse do |post|
      post.tags = post.categories.select{|c|c.domain == 'post_tag'}
      post.categories = post.categories.select{|c|c.domain == 'category'}
    end
  end
end
