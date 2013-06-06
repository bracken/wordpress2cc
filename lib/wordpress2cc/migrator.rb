module Wordpress2CC
  class Migrator
    def initialize(source, destination, options={})
      @source = source
      @destination = destination
      Wordpress2CC::Logger.logger = options['logger'] || ::Logger.new(STDOUT)
      raise(Wordpress2CC::Error, "'#{@source}' does not exist") unless File.exists?(@source)
      raise(Wordpress2CC::Error, "'#{@destination}' is not a directory") unless File.directory?(@destination)
    end

    def migrate
      backup = WordPress2CC::Backup.new @source
      backup.parse!
      @converter = Wordpress2CC::CC::Converter.new backup, @destination
      @converter.convert
    rescue StandardError => error
      Wordpress2CC::Logger.add_warning 'error migrating content', error
    end

    def imscc_path
      @converter.imscc_path
    end
  end
end
