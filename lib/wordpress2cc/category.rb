module Wordpress2CC
  class Category
    include HappyMapper

    tag 'category'
    attribute :domain, String
    attribute :nicename, String
    content :name
    element :category_nicename, String, :tag => 'wp:category_nicename'
  end
end
