module Wordpress2CC
  class Channel
    include HappyMapper

    tag 'channel'
    element :title, String, :tag => 'title'
    element :description, String, :tag => 'description'
    element :pub_date, String, :tag => 'pubDate'
    element :language, String, :tag => 'language'
    element :wp_version, String, :tag => 'wp:wxr_version'
    has_many :categories, Wordpress2CC::TopCategory
    has_many :posts, Wordpress2CC::Post
    attr_reader :id

    def self.read(backup_file)
      xml = File.read(backup_file)
      backup = parse xml
      backup
    end
  end
end
