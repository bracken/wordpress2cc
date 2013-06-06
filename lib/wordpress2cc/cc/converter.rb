module Wordpress2CC::CC
  class Converter
    include Moodle2CC::CC::CCHelper

    def initialize(wp_backup, destination_dir)
      @backup = wp_backup
      @export_dir = Dir.mktmpdir
      @destination_dir = destination_dir
    end

    def imscc_file_name
      "#{file_slug(@backup.channel.title)}.imscc"
    end

    def imscc_path
      @imscc_path ||= File.join(@destination_dir, imscc_file_name)
    end

    def imscc_tmp_path
      @imscc_tmp_path ||= File.join(@export_dir, imscc_file_name)
    end

    def convert
      File.open(File.join(@export_dir, MANIFEST), 'w') do |file|
        @document = Builder::XmlMarkup.new(:target => file, :indent => 2)
        @document.instruct!
        create_manifest
      end
      Zip::ZipFile.open(imscc_tmp_path, Zip::ZipFile::CREATE) do |zipfile|
        Dir["#{@export_dir}/**/*"].each do |file|
          zipfile.add(file.sub(@export_dir + '/', ''), file)
        end
      end
      FileUtils.mv imscc_tmp_path, imscc_path
      FileUtils.rm_r @export_dir
    end

    def create_manifest
      @document.manifest(
        "identifier" => create_key(@backup.channel.title, "common_cartridge_"),
        "xmlns" => "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1",
        "xmlns:lom" => "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource",
        "xmlns:lomimscc" => "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imscp_v1p2_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lomresource_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lommanifest_v1p0.xsd"
      ) do |manifest_node|
        @manifest_node = manifest_node
        @manifest_node.metadata do |md|
          md.schema "IMS Common Cartridge"
          md.schemaversion "1.1.0"
          md.lomimscc :lom do |lom|
            lom.lomimscc :general do |general|
              general.lomimscc :title do |title|
                title.lomimscc :string, @backup.channel.title
              end
            end
            lom.lomimscc :lifeCycle do |lifecycle|
              lifecycle.lomimscc :contribute do |contribute|
                contribute.lomimscc :date do |date|
                  date.lomimscc :dateTime, ims_date
                end
              end
            end
            lom.lomimscc :rights do |rights|
              rights.lomimscc :copyrightAndOtherRestrictions do |node|
                node.lomimscc :value, 'yes'
              end
              rights.lomimscc :description do |desc|
                desc.lomimscc :string, 'Private (Copyrighted) - http://en.wikipedia.org/wiki/Copyright'
              end
            end
          end
        end

        create_organizations

        @manifest_node.resources do |resources_node|
          create_resources(resources_node)
        end
      end
    end

    def create_organizations
      @manifest_node.organizations do |orgs|
        orgs.organization(
          :identifier => 'org_1',
          :structure => 'rooted-hierarchy'
        ) do |org|
          org.item(:identifier => "LearningModules") do |root_item|
            if @backup.pages.any?
              root_item.item(:identifier => create_key("pages")) do |item_node|
                item_node.title "Pages"
                @backup.pages.each do |page|
                  item_node.item(:identifier => 'item1', :identifierref => create_key(page.post_id)) do |sub_item|
                    sub_item.title page.title
                  end
                end
              end
            end

            # todo - something interesting with sub-categories
            @backup.categories.each do |cat|
              next unless @backup.posts.any? { |p| p.categories.any? { |c| c.name == cat.name } }
              root_item.item(:identifier => create_key(cat.name)) do |item_node|
                item_node.title cat.name
                @backup.posts.find_all { |p| p.categories.any? { |c| c.name == cat.name } }.each do |page|
                  item_node.item(:identifier => 'item1', :identifierref => create_key(page.post_id)) do |sub_item|
                    sub_item.title page.title
                  end
                end
              end
            end
          end
        end
      end
    end

    def create_resources(resources_node)
      @backup.pages.each do |page|
        create_resource_node(resources_node, page, 'pages')
        create_files(page, 'pages')
      end
      @backup.posts.each do |post|
        create_resource_node(resources_node, post, 'posts')
        create_files(post, 'posts')
      end
    end

    def create_resource_node(resources_node, post, dir)
      href = "#{dir}/#{post.post_name}.html"
      resources_node.resource(
        :href => href,
        :type => WEBCONTENT,
        :identifier => create_key(post.post_id)
      ) do |resource_node|
        resource_node.file(:href => href)
      end
    end

    def create_files(post, dir)
      path = File.join(@export_dir, dir, post.post_name + ".html")
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        file << HTML_TEMPLATE % [post.title, create_key(post.post_id), post.content]
      end
    end

    HTML_TEMPLATE = <<HTML
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <title>%s</title>
    <meta name="identifier" content="%s"/>
  </head>
  <body>
    %s
  </body>
</html>
HTML

  end
end
