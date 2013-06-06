require 'thor'

module Wordpress2CC
  class CLI < Thor
    desc "migrate WORDPRESS_BACKUP_XML EXPORT_DIR", "Migrates WordPress backup XML to IMS Common Cartridge package"
    def migrate(source, destination)
      migrator = Wordpress2CC::Migrator.new source, destination, options
      migrator.migrate
      puts "#{source} converted to #{migrator.imscc_path}"
    end
  end
end
