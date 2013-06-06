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

  def test_has_posts
    assert_equal @backup.posts.count, 5
  end

  def test_has_pages
    assert_equal @backup.pages.count, 7
  end
end
