module Wordpress2CC
  class Backup
    attr_reader :channel, :posts, :pages

    def initialize(backup_path)
      @backup_path = backup_path
    end

    def parse!
      @channel = Channel.read(@backup_path).first
      @posts = @channel.posts.select{|p| p.post_type == 'post'}
      @pages = @channel.posts.select{|p| p.post_type == 'page'}
    end

  end
end
