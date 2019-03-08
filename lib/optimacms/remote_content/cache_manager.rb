module Optimacms
  module RemoteContent
    class CacheManager

      def self.remove_templates(source_name)
        a_paths = Page.where(template_source: source_name).where("template_path IS NOT NULL AND template_path <> ''").pluck(:template_path).to_a


        a_paths.each do |s|
          path = File.join(Rails.root, Optimacms.config.templates_remote_dir, s)

          File.delete(path) if File.exist?(path)

        end

        #Page.where(template_source: source_name).where("template_path_local IS NOT NULL").update_all("template_path_local=''")


        true
      end

      def self.remove_content(source_name=nil)
        d = Optimacms.config.remote_content_cache_dir

        if source_name.nil?
          dd = File.join(Rails.root, d)
          FileUtils.rm_rf(Dir.glob(dd+'/*'))
        else
          dd = File.join(Rails.root, d, source_name)
          FileUtils.rm_rf(Dir.glob(dd+'/*'))
        end

        true
      end
    end
  end
end

