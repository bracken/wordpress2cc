require 'minitest/autorun'
require 'test_helper'
require 'wordpress2cc'
require 'pp'

class TestUnitMoodleBackup < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @backup = Wordpress2CC::Backup.new(backup_fixture)
    @backup.parse!
  end

  def test_has_all_posts
    assert_equal @backup.posts.count, 5
  end

  def test_has_post_data
    post = @backup.posts.find{|p| p.post_id == '2'}
    assert_equal post.content, "Need stuff for <strong>testing</strong>"
    assert_equal post.title, 'First Post'
    assert_equal post.status, 'publish'
  end

  def test_has_all_pages
    assert_equal @backup.pages.count, 7
  end

  def test_has_categories
    post = @backup.posts.find{|p| p.post_id == '20'}
    assert_equal post.categories.length, 2
    assert post.categories.find{|c| c.name == 'cool'}
    assert post.categories.find{|c| c.name == 'kind of'}
  end

  def test_has_tags
    post = @backup.posts.find{|p| p.post_id == '2'}
    assert_equal post.tags.length, 2
    assert post.tags.find{|c| c.name == 'tags'}
    assert post.tags.find{|c| c.name == 'yay'}
  end
end
