module Wordpress2CC
  class Category
    include HappyMapper

    tag 'category'
    attribute :domain, String
    attribute :nicename, String
    content :name
  end
end
