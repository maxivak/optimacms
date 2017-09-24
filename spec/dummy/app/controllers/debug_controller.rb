class DebugController < ApplicationController

  def metadata_backup
    res = Optimacms::BackupMetadata::TemplateImport.perform_backup

    x =0

  end

  def import_templates
    dirname = "/data/projects/myrails/cms/site/spec/dummy/temp/metadata/2017.09.09.17.08.31"

    @templates = Optimacms::BackupMetadata::TemplateImport.analyze_data_templates(dirname)

    x =0

  end

  def analyze_import_template
    @filename = "/data/projects/myrails/cms/site/spec/dummy/temp/metadata/example/templates/newfolder--t1.json"



    @res = Optimacms::BackupMetadata::TemplateImport.analyze_template_file(@filename)




  end

  def import_template
    @dirname = "/data/projects/myrails/cms/site/spec/dummy/temp/metadata/2017.09.20.20.21.07/templates"
    @filename = "pages--iphone7.json"
    @cmd = "add"
    #@cmd = "update"

    @res = Optimacms::BackupMetadata::TemplateImport.import_template(@dirname, @filename, @cmd)


    x =0

  end



end
