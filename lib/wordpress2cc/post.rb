module Wordpress2CC
  class Post
    include HappyMapper

    tag 'item'
    element :title, String, :tag => 'title'
    element :pudDate, String, :tag => 'pubDate'
    element :content, String, :tag => 'content:encoded'
    element :post_id, String, :tag => 'wp:post_id'
    element :status, String, :tag => 'wp:status'
    element :post_parent, String, :tag => 'wp:post_parent'
    element :post_type, String, :tag => 'wp:post_type'

    after_parse do |item|
    end
  end
end
