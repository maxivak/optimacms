module Optimacms
  class Admin::TemplatesController < Admin::AdminBaseController

    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :init_common
    before_action :init_data_form, only: [:new, :edit, :update, :create, :newfolder, :editfolder, :newattach]
    #before_action :set_layout_modal


    def init_common
      @modal = (params[:modal] || 0).to_i
      set_layout_modal(@modal)

    end

    def set_layout_modal(modal)
      if modal.to_i==1
        #self.class.layout false
      end

    end


    def index
      #@filter.clear_data

      #
      @parent_id = @filter.v('parent_id').to_i
      @parent = Template.find(@parent_id) rescue nil

      if @parent.nil? && @parent_id>0
        redirect_to templates_path(:parent_id=>0) and return
      end

      #
      @items = model.by_filter(@filter)
      #@items = model.where(@filter.where).order(@filter.order_string).page(@filter.page)


    end

    #include SimpleFilter::Controller
    search_filter :index, {save_session: true, search_method: :post_and_redirect, url: :templates_url, search_url: :search_templates_url, search_action: :search} do
      # define filter
      default_order "title", 'asc'

      # fields
      field :title, :string, :text, {label: '', default_value: '', condition: :like_full}
      #field :parent_id, :int, :hidden, {label: '', default_value: 0, ignore_value: 0, condition: :empty}
      field :parent_id, :int, :hidden, {label: '', default_value: 0, ignore_value: -1, condition: :custom, condition_scope: :of_parent}

      #field :category_id, :int, :select, {collection: [['UGX- Uganda Shillings',1],['USD- US Dollars',2]], label_method: :first, value_method: :last}
      #field :type_id, :int, :select, {label: 'Type', default_value: 0, collection: TemplateType.all, label_method: :title, value_method: :id}
      #field :type, :string, :autocomplete, {label: 'Type', default_value: '', :source_query => :autocomplete_templates_url}

    end



    def autocomplete
      q = params[:q]
      type_id = (params[:t] || TemplateType::TYPE_PAGE).to_i

      rows = Template.where("type_id=#{type_id} AND (basepath LIKE ? OR title like ?)", "%#{q}%", "%#{q}%").order('basepath asc').limit(20)

      data = rows.map{|r| [r.id, "#{r.title} (#{r.basepath})"]}
      render :json => data
    end

    def show
    end

    def new
      @item = model.new({:tpl_format=>Optimacms::Template::EXTENSION_DEFAULT, :type_id=>TemplateType::TYPE_PAGE})
      item_init_parent
      @item.set_basedirpath_from_parent

      @url_back = url_list
    end


    def create
      @item = model.new(item_params)
      @res = @item.save



      respond_to do |format|
        if @res
          format.html {  redirect_to edit_template_path(@item), success: 'Successfully created' }
          #format.json {  render json: @item, status: :created, location: user_clients_url(:action => 'index')        }
          format.js {}
        else
          format.html {  render :new }
          #format.json { render json: @item.errors, status: :unprocessable_entity }
          format.js {}
        end
      end
    end


    def edit
      @item.build_translations
      @item.save
      @item.reload

    end


    def update
      # fix line breaks
      #content = data[:content]
      #content.gsub! /\r\n/, "\n"

      @item.attributes = item_params
      @res = @item.save
      #@res = @item.update(item_params)

      #@res = false

      if @res
        redirect_to url_list, success: 'Successfully updated'
      else
        render :edit
      end
    end


    def destroy
      @res = @item.destroy

      if @res
        redirect_to url_list, success: 'Successfully deleted'
      else
        redirect_to url_list, error: 'Cannot delete'
      end
    end


    ### layout


    def newlayout
      @item = model.new({:tpl_format=>Optimacms::Template::EXTENSION_DEFAULT, :type_id=>TemplateType::TYPE_LAYOUT})
      item_init_parent
      @item.set_basedirpath_from_parent

      @url_back = url_list
    end


    def createlayout
      @item = model.new(item_params)
      @res = @item.save

      respond_to do |format|
        if @res
          format.html {  redirect_to edit_template_path(@item), success: 'Successfully created' }
          #format.json {  render json: @item, status: :created, location: user_clients_url(:action => 'index')        }
          format.js {}
        else
          format.html {  render :new }
          #format.json { render json: @item.errors, status: :unprocessable_entity }
          format.js {}
        end
      end
    end


    ### attach

    def newattach
      @item = model.new({:tpl_format=>Optimacms::Template::EXTENSION_DEFAULT})
      item_init_parent
      @item.set_basedirpath_from_parent

      @url_back = url_list
    end

    def attach
      item_params = params.require(model_name).permit!
      #(:title, :basepath, :parent_id, :tpl_format)
      item_params[:type_id] = TemplateType::TYPE_PAGE
      @item = model.new(item_params)
      @res = @item.attach

      respond_to do |format|
        if @res
          format.html {  redirect_to edit_template_path(@item), success: 'Successfully attached' }
          #format.json {  render json: @item, status: :created, location: user_clients_url(:action => 'index')        }
          format.js {}
        else
          format.html {  render :newattach }
          #format.json { render json: @item.errors, status: :unprocessable_entity }
          format.js {}
        end
      end
    end


    #### folders


    def newfolder
      @item = model.new(:is_folder=>true)
      item_init_parent
      @item.basedirpath = @item.parent.basepath+'/' unless @item.parent_id.nil?

    end

    def createfolder
      item_params = params.require(model_name).permit(:title, :basename, :parent_id, :is_folder)

      @item = model.new(item_params)
      @res = @item.save

      if @res
        redirect_to url_list, success: 'Successfully created'
      else
        render :newfolder
      end
    end


    def editfolder
      @item = Template.folders.find(params[:id])

      return url_list if @item.nil?

    end

    def updatefolder
      @item = Template.folders.find(params[:id])
      item_params = params.require(model_name).permit(:title, :basename, :parent_id, :is_folder)
      @res = @item.update_attributes(item_params)

      if @res
        redirect_to url_list, success: 'Successfully updated'
      else
        render :editfolder
      end
    end



    private

    def init_data_form
      @url_back = url_list

      @languages = Language.list_with_default
    end


    def model
      Template
    end
    def model_name
      :template
    end

    def url_list
      templates_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = model.find(params[:id])

      @url_back = url_list
    end

    def item_init_parent
      parent_id = params[:parent_id]
      parent_id = parent_id.to_i unless parent_id.nil?
      parent_id = nil if parent_id==0

      @item.parent_id = parent_id
    end

    def item_params
      #params.require(model_name).permit(:title)
      params.require(model_name).permit!
    end


    # filter

    def filter_prefix
      'admin_templates_index_'
    end

    def init_tabledata
      init_filter
    end

    def init_filter
      # input
      @pg = params[:pg].to_i || 1

      #
      @filter = Filters::FormFilter.new(session, filter_prefix)

      # set filter fields
      @filter.add_fields_from_array(
          [
              {name: 'title', type: 'text', dbtype: Filters::FormFilter::DBTYPE_STRING, title: 'Title', def: '', opt: {width: 120}},
              {name: 'parent_id', type: 'int', dbtype: Filters::FormFilter::FIELD_TYPE_HIDDEN, title: '', def: 0},
          ]
      )

      #
      if params.has_key? :parent_id
        @filter.set 'parent_id', params[:parent_id]
      end
      #@filter.set 'owner_id', current_user.owner_id

      #
      @cmd = params[:cmd] || ''


      # post
      if request.post? && params[:filter]
        if params[:cmd]=='clear'
          @filter.clear_data

          redirect_to url_list and return
        else
          @filter.set_data_from_form(params[:filter] || [])
          redirect_to url_list and return
        end

      end

      # order
      @filter.set_order_default('created_at' ,'desc')
      #@filter.set_order('created_at' ,'desc')

      if @cmd=='order'
        @filter.set_order params[:orderby], params[:orderdir]
        redirect_to url_list and return
      end


    end


    def table_columns
      @table_columns = [
          {name: "id", title: "##"},
          {name: "title", title: "title"},
      ]
    end

  end
end
