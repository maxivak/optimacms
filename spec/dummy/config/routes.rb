Rails.application.routes.draw do

  # users for optimacms
  devise_for :cms_admin_users, Optimacms::Devise.config

  # usual

  devise_for :users

  get 'hello.html', to: 'my#hello', as: 'hello'

  # debug
  get '/debug/:action', to: 'debug#action', as: 'debug'


  # extend admin area
  scope '/'+Optimacms.config.main_namespace+'/'+Optimacms.config.admin_namespace, module: "optimacms" do
    namespace :admin do
      resources :news do
        collection do
          post 'search'
        end
      end
    end
  end


  # the last!!!
  mount Optimacms::Engine => '/'+Optimacms.config.main_namespace

  #
  root to: 'home#index'


  # all pages
  #scope module: 'optimacms' do
  #  match '*path', :to => 'pages#show', via: :all
  #end

  #, format: false
  # , constraints: -> (req) { !(req.fullpath =~ /^\/assets\/.*/) }
end
