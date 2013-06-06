module Wordpress2CC
  class TopCategory
    include HappyMapper

    tag 'wp:category'
    element :nicename, String, :tag => 'wp:category_nicename'
    element :parent, String, :tag => 'wp:category_parent'
    element :name, String, :tag => 'wp:cat_name'
  end
end
