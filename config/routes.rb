Optimacms::Engine.routes.draw do
  # dev
  #get 'dev/:action', to: 'dev#action'

  # admin
  scope '/'+Optimacms.config.admin_namespace, module: "admin" do
    #devise_for :users, { class_name: "Optimacms::User", module: :devise }

    get '/' => 'dashboard#index', as: :dashboard

    get '/res' => 'common#res', as: :res_common

    resources :languages do
      collection do
        post 'search'
      end
    end

    resources :pages do
      collection do
        post 'search'

        get 'newfolder'
        post 'createfolder'

        get :newtextpage
        post :createtextpage

      end

      member do
        get 'editfolder'
        patch 'updatefolder'

        get 'edit_template_content'
      end
    end

    resources :templates do
      collection do
        post 'search'

        get :autocomplete
        get :autocomplete_path

        get 'newattach'
        post 'attach'

        get 'newfolder'
        post 'createfolder'


        get :newlayout
        post :createlayout

        get :newblock
        post :createblock

        get :panel_blocks

      end

      member do
        get 'editfolder'
        patch 'updatefolder'
      end
    end

    resources :layouts

    resources :css_files, only: [:index] do

      collection do
        post 'search'

        get :autocomplete
      end
    end


    get 'css_files/edit', to: 'css_files#edit',  as: :edit_css_file
    post 'css_files/update', to: 'css_files#update',  as: :update_css_file


    resources :mediafiles, only: [:index]
    #get '/elfinder_manager', to: 'elfinder#index'
    match '/media_elfinder' => 'mediafiles#elfinder', via: [:get, :post]


    resources :resources do
      collection do
        post 'search'
      end

      member do
        get 'usage'
      end
    end

    resources :users do
      collection do
        post 'search'
      end

    end


    # remote content
    resources :content_sources, only: [:index, :show] do
      collection do
      end

      member do
        get 'clean_cache'
      end
    end


    # deploy
    resources :appdata, only: [:index] do
      collection do
        get 'save'
        get 'get'
      end
    end


    # maintenance
    get '/optimacms/maintenance', to: 'maintenance#index', as: :maintenance

    scope '/optimacms/maintenance', module: 'maintenance', as: "maintenance" do
      get 'restart'
      get 'info'
      get 'assets_precompile'
    end


    # logs
    resources :rails_logs, only: [:index] do
    end
    get 'rails_logs/:name', to: "rails_logs#list_logs", as: 'list_logs'


    # backup metadata
    resources :backup_metadata, only: [:index] do
      collection do
        get 'backup'

        get 'view'
        get 'download'
        get 'delete'

        post 'upload'

        get 'reviewimport_templates'
        get 'import_template'

        get 'reviewimport_pages'
        get 'import_page'
      end
    end


  end


  # tinymce
  #post '/tinymce_assets' => 'tinymce_assets#create', as: :tinymce_uploadimage
  get '/elfinder_manager', to: 'elfinder#index'
  match 'elfinder' => 'elfinder#elfinder', via: [:get, :post]

  # OK. 2019-01-14
  root to: 'pages#show'
  match '*url', :to => 'pages#show', via: :all, format: false, as: :cms_page


end
