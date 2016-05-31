module Optimacms
  class Template < ActiveRecord::Base
    self.table_name = 'cms_templates'

    EXTENSION_DEFAULT = 'html'
    EXTENSIONS = {'blank'=>'', 'html'=>'html', 'erb'=>'html.erb', 'haml'=>'html.haml'}


    belongs_to :type, :foreign_key => 'type_id', :class_name => 'TemplateType'

    has_many :translations, foreign_key: 'item_id', class_name: 'TemplateTranslation', dependent: :destroy
    accepts_nested_attributes_for :translations


    ### callbacks
    before_validation :_before_validation
    before_create :_before_create
    before_update :_before_update
    before_destroy :_before_destroy

    # tree
    has_ancestry

    #
    #validate :check_unique_path,  unless: :is_folder?
    validates_uniqueness_of :basepath, :scope => :is_folder

    #validate :check_parent_folder_exists,  unless: :is_folder?

    #
    paginates_per 10


    # scopes
    scope :folders, -> { where(is_folder: true) }
    scope :layouts, -> { where(is_folder: false, type_id: TemplateType::TYPE_LAYOUT) }

    scope :of_parent, lambda {  |parent_id| where_parent(parent_id) }

    # search
    searchable_by_simple_filter



    ###
    def to_s
      "#{title} (#{basepath})"
    end


    ### settings

    def self.base_dir
      Rails.root.to_s + '/app/views/'
    end





    ### properties

    def parent_title
      self.parent.title
    end


    def has_code?
      ['haml', 'erb', 'blank'].include?(self.tpl_format)
    end

    def is_folder?
      self.is_folder
    end

    def is_layout?
      return self.type_id==TemplateType::TYPE_LAYOUT
    end

    def is_type_page?
      return self.type_id==TemplateType::TYPE_PAGE
    end

    def is_type_partial?
      return self.type_id==TemplateType::TYPE_PARTIAL
    end



    ### translations

    def build_translations
      #
      if is_translated
        langs = Language.list_with_default
      else
        langs = ['']
      end

      #
      langs_missing = langs - self.translations.all.map{|r| r.lang}

      langs_missing.each do |lang|
        self.translations.new(:lang=>lang)
      end

    end


    ##### search

    def self.where_parent(parent_id)
      if parent_id==0
        roots
      elsif parent_id>0
        children_of(parent_id.to_s)
      end
    end



    #### operations

    def attach
      # check if file exists
      if !content_file_exists?
        errors.add(:attach, "file not found")
        return false
      end

      save
    end



    #### path

    def path(lang='')
      return nil if self.basename.nil?
      self.basedirpath + filename_base + Template.filename_lang_postfix(lang) + Template.filename_ext_with_dot(self.tpl_format)
    end

    def fullpath(lang='')
      f = self.path(lang)
      return nil if f.nil?
      Template.base_dir + f
    end

    def content_file_exists?(lang='')
      postfixes = EXTENSIONS.map{|k,v| '.'+v}

      found = false
      postfixes.each do |p|
        if File.exists?(self.fullpath(lang))
          found = true
          break
        end
      end
      found
    end


    ### validations

    def check_parent_folder_exists
      if self.parent_id.nil? && !self.basedirpath.blank?
        errors.add(:basedirpath, "folder not exists. create it first")
      end
    end




    ##### folder

    def folder_path
      return nil if self.basepath.nil?
      self.basepath+'/'
    end

    def folder_fullpath
      f = self.folder_path
      return nil if f.nil?
      Template.base_dir + f
    end



    ### content

    def content(lang='')
       filename =  fullpath(lang)
       return nil if filename.nil?
       return '' if !File.exists? filename
       File.read(filename)
     end

     def content=(v, lang='')
       File.open(self.fullpath(lang), "w+") do |f|
         f.write(v)
       end
     end


    ### helpers for path

    # base filename depending on  type
    # for page = name
    # for partial = _name
    def filename_base
      return '_'+self.basename if self.is_type_partial?

      self.basename
    end


    def self.filename_lang_postfix(lang)
      return '' if lang==''
      return '.'+lang
    end

    def self.filename_ext(format)
      EXTENSIONS[format]
    end

    def self.filename_ext_with_dot(format)
      ext = filename_ext(format)
      ext = '.'+ext unless ext.blank?
      ext
    end


    ### operations with path

    def set_basepath
      if self.parent.nil?
        self.basepath = self.basename
        self.basedirpath ||= ''
      else
        self.basepath = self.parent.basepath+'/'+self.basename
        self.basedirpath ||= self.parent.basepath+'/'
      end

    end


    def fix_basedirpath
      self.basedirpath ||= ''
      if !self.basedirpath.blank? && self.basedirpath[-1] !='/'
        self.basedirpath << '/'
      end
    end

    def set_basedirpath_from_parent
      v = ''
      if self.parent_id.nil?
        v = ''
      else
        v = self.parent.basepath+'/' if self.parent_id >0
      end

      self.basedirpath = v
      #v
    end

    def set_parent_from_basedirpath
      v = self.basedirpath

      # set parent_id from dir
      d = v.chop
      r = Template.where(is_folder: true, basepath: d).first
      if r
        self.parent_id = r.id
      else
        self.parent_id = nil
      end
    end



    #### callbacks

    def _before_validation
      fix_basedirpath

      # parent, basedirpath
      if self.parent_id.nil? && !self.basedirpath.blank?
        set_parent_from_basedirpath
      elsif self.basedirpath.nil? && !self.parent_id.nil?
        set_basedirpath_from_parent
      end

      set_basepath
    end


    def _before_create
      if self.is_folder
        # create dir on disk
        Fileutils::Fileutils.create_dir_if_not_exists self.folder_fullpath
      else
        # add folders if needed
        if self.parent_id.nil? && !self.basedirpath.blank?
          self.parent = Template.create_folders_tree(self.basedirpath)
        end

      end

    end

    def _before_update
      if self.is_folder
        oldpath = self.folder_fullpath

        self.set_basepath

        # rename dir on disk
        if self.basename_changed?
          raise "cannot change folder path"

          require 'fileutils'
          newpath = self.folder_fullpath

          if Dir.exists?(newpath)
            errors.add(:basename, 'Folder already exists')
            return false
          end

          FileUtils.mv oldpath, newpath

          # TODO: change paths for child templates

        end

      else
        # file

        # TODO: rename file
        #self.make_basepath

      end

    end

    def _before_destroy
      if self.is_folder

        # cannot delete not empty dir
        if !self.folder_empty?
          return false
        end

        # delete dir
        folder_delete

      else
        # file


      end


      true
    end


    # create folders if necessary - NOT WORKING
    def self.create_folders_tree(dirpath)
      a = dirpath.split /\//

      d = ''
      parent_current = nil
      prev_d = d
      a.each do |s|
        d = d + (d=='' ? '' : '/') +s
        r = Template.where(is_folder: true, basepath: d).first
        if r
          parent_current = r
          next
        end
        # create missing folder
        path_new = File.basename(d)
        basedirpath_new = prev_d
        r = Template.create(is_folder: true, basename: path_new, basedirpath: basedirpath_new, title: path_new, parent: parent_current)
        parent_current = r

        prev_d = d
      end

      parent_current

    end


    #### folders

    def folder_delete
      dirpath = self.folder_fullpath
      FileUtils.remove_dir(dirpath) if Dir.exists? dirpath
    end

    def folder_empty?
      dirpath = self.folder_fullpath
      if !Dir.exists? dirpath
        return true
      end

      return Dir.entries(dirpath).size == 2
    end

  end
end
