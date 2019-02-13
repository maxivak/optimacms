module Optimacms
  class Admin::PagesController < Admin::AdminBaseController

    before_action :set_item, only: [:show, :edit, :update, :destroy, :editfolder, :updatefolder]
    before_action :init_data_form, only: [:edit, :new, :create, :update, :newtextpage, :createtextpage, :reviewimport]


    def index
      @items = model.includes(:template).by_filter(@filter)
      #@items = model.where(@filter.where).order(@filter.order_string).page(@filter.page)

      #
      @parent_id = @filter.v('parent_id')
      @parent_id = nil if @parent_id && @parent_id==0
      #@parent_id = (@parent_id || 0).to_i
      @parent = Page.find(@parent_id) rescue nil

    end

    def search_old
      redirect_to pages_path
    end



    def url_list
      pages_url
    end



    search_filter :index, {save_session: true, search_method: :post_and_redirect, url: :pages_url, search_url: :search_pages_url} do
      default_order "created_at", 'desc'

      # fields
      field :title, :string, :text, {label: '', default_value: '', condition: :like_full}
      #field :parent_id, :int, :hidden, {label: '', default_value: 0, ignore_value: -1}
      field :parent_id, :int, :hidden, {label: '', default_value: 0, ignore_value: -1, condition: :custom, condition_scope: :of_parent}
    end


    def init_filter_old

      # input
      @pg = params[:pg].to_i || 1

      #
      @filter = Filters::FormFilter.new(session, 'admin_pages')

      # set filter fields
      @filter.add_fields_from_array(
          [
              #{name: 'uid', type: 'text', dbtype: FormFilter::DBTYPE_STRING, title: 'UID', def:'', opt: {width: 80}},
              #{name: 'status', type: 'text', dbtype: FormFilter::DBTYPE_STRING, title: 'Status', def: '', opt: {width: 120}},
              {name: 'title', type: 'text', dbtype: Filters::FormFilter::DBTYPE_STRING, title: 'Title', def: '', opt: {width: 120}},
              {name: 'parent_id', type: 'int', dbtype: Filters::FormFilter::FIELD_TYPE_HIDDEN, title: '', def: 0},
              #{name: 'client_id', type: FormFilter::FIELD_TYPE_HIDDEN, dbtype: FormFilter::DBTYPE_INT, title: 'Client', def: 0, opt: {width: 120}},
              #{name: 'client', type: FormFilter::FIELD_TYPE_SELECT_AUTO,  dbtype: FormFilter::DBTYPE_STRING, title: 'Client', def: '', opt: {width: 120, field_id:'client_id', url_query: clients_url(:action=>'list')}},

              #{name: 'status_id', type: FormFilter::FIELD_TYPE_HIDDEN,  dbtype: FormFilter::DBTYPE_INT, title: 'Status', def: 0, opt: {width: 120}},
              #{name: 'status', type: FormFilter::FIELD_TYPE_SELECT_AUTO,  dbtype: FormFilter::DBTYPE_STRING, title: 'Status', def: '', opt: {width: 120, field_id:'status_id', url_query: statuses_url(:action=>'list')}},

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

    def show
    end

    def new
      @item = model.new
      @item.build_translations
      @item[:parent_id] = params.fetch(:parent_id, nil)

      @url_back = url_list
    end

    def edit
      @item.build_translations

      @url_back = url_list
    end


    def create
      @item = model.new(item_params)
      @res = @item.save

      if @res
        redirect_to url_list, success: 'Successfully created'
      else
        render :new
      end
    end

    def update
      @res = @item.update(item_params)

      if @res
        u = params[:continue]=="1" ? edit_page_path(@item) : url_list
        redirect_to u, success: 'Successfully updated'
      else
        render :edit
      end

    end


    def destroy
      @item.destroy
      redirect_to url_list, success: 'Successfully destroyed'
    end

    def init_data_form
      @layouts = Template.layouts.all
      @languages = Language.list_with_default
    end

    def newfolder
      @item = model.new(:is_folder=>true)
      @item.parent_id = params.fetch(:parent_id, nil)

      @url_back = url_list
    end

    def createfolder
      item_params = params.require(model_name).permit!
      @item = model.new(item_params)
      @res = @item.save

      if @res
        redirect_to url_list, success: 'Successfully created'
      else
        render :newfolder
      end
    end


    def editfolder
      return url_list if @item.nil?

      @url_back = url_list
    end

    def updatefolder
      @res = @item.update_attributes(item_params)

      if @res
        redirect_to url_list, success: 'Successfully updated'
      else
        render :editfolder
      end
    end


    ### text page

    def newtextpage
      @item = model.new
      @item.parent_id = params.fetch(:parent_id, nil)

      @item.build_template

      #
      @url_back = url_list
    end

    def createtextpage
      textpage_params = params.require(model_name).permit(:title, :name, :layout_id, :is_translated, :parent_id, :url,
                                                          template_attributes: [:basedirpath, :name, :title, :type_id, :tpl_format])
      @item = model.new(textpage_params)

      # predefined data
      @item.template.title = @item.title
      @item.template.basename = @item.name
      @item.template.type_id = TemplateType::TYPE_PAGE
      @item.template.is_translated = @item.is_translated

      @res = @item.save

      if @res
        redirect_to url_list, success: 'Successfully created'
      else
        render :newtextpage
      end
    end




    ### for remote content

    def edit_template_content
      # input
      page_id = params[:id]

      source_file_url = params[:source_file_url]

      #
      if source_file_url
        redirect_to source_file_url and return
      end


      page = Page.find(page_id)
      content_block = Optimacms::ContentBlock::Factory.for_page(page)

      content_block.get_file_info

      if content_block.is_local?
        redirect_to edit_template_path(page.template_id) and return
      else
        source_file_url = content_block.remote_file_url
        if source_file_url
          redirect_to source_file_url and return
        end
      end

      raise 'not found'
    end

    ####

    def table_columns

      @table_columns = [
          {name: "id", title: "##"},
          {name: "title", title: "title"},
      ]
    end


    private
      def model
        Page
      end
      def model_name
        :page
      end


      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = model.find(params[:id])

        @url_back = url_list
      end

      def item_params
        #params.require(model_name).permit(:title)
        params.require(model_name).except(:template).permit!
        #item_params[:page].delete(:template)
      end


  end


end
