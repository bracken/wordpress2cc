module Wordpress2CC
  class Channel
    include HappyMapper

    tag 'channel'
    has_many :posts, Wordpress2CC::Post

    def self.read(backup_file)
      xml = File.read(backup_file)
      backup = parse xml
      backup
    end
  end
end
