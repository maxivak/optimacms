Optimacms::Engine.routes.draw do

  # admin
  scope '/'+Optimacms.admin_namespace, module: "admin" do
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
      end
    end

    resources :templates do
      collection do
        post 'search'

        get :autocomplete

        get 'newattach'
        post 'attach'

        get 'newfolder'
        post 'createfolder'


        get :newlayout
        post :createlayout

        get :newblock
        post :createblock
      end

      member do
        get 'editfolder'
        patch 'updatefolder'
      end
    end

    resources :layouts

    resources :mediafiles, only: [:index]
    #get '/elfinder_manager', to: 'elfinder#index'
    match '/media_elfinder' => 'mediafiles#elfinder', via: [:get, :post]


    resources :app_sys do
      collection do
        get :restart
      end

    end


  end

  # dev
  get 'dev/:action', to: 'dev#action'

  # tinymce
  #post '/tinymce_assets' => 'tinymce_assets#create', as: :tinymce_uploadimage
  get '/elfinder_manager', to: 'elfinder#index'
  match 'elfinder' => 'elfinder#elfinder', via: [:get, :post]

  #
  root to: 'pages#show'
  match '*url', :to => 'pages#show', via: :all, format: false, as: :cms_page


end
