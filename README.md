# Wordpress2CC

Wordpress2CC will convert WordPress backup files into IMS Common Cartridge 1.1
formatted files. 

Word Press information: http://ipggi.wordpress.com/2011/03/16/the-wordpress-extended-rss-wxr-exportimport-xml-document-format-decoded-and-explained/

Common Cartridge information: http://www.imsglobal.org/cc/index.html

Use the [Github Issues](https://github.com/bracken/wordpress2cc/issues?state=open)
for feature requests and bug reports.

## Installation/Usage

### Command line
Install RubyGems on your system, see http://rubygems.org/ for instructions.
Once RubyGems is installed you can install this gem:

    $ gem install wordpress2cc

Convert a WordPress .xml backup into Common Cartridge format

    $ wordpress2cc migrate <path-to-wordpress-backup> <path-to-cc-export-directory>

### In a Ruby application

Add this line to your application's Gemfile and run `bundle`:

    gem 'wordpress2cc'

Require the library in your project and use the migrator:

```ruby
require 'wordpress2cc'
migrator = Wordpress2CC::Migrator.new wordpress_xml_path, destination_bath
migrator.migrate
```

## Contributing

Run the tests:

    $ bundle exec rake

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
