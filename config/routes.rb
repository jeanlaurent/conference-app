ConferenceOnRails::Application.routes.draw do
  # 1- devise
  devise_for :users, :controllers => {
    :sessions => 'auth/sessions',
    :registrations => 'auth/registrations',
    :omniauth_callbacks => 'auth/callbacks'
  }
  resources :companies

  resources :conferences do
    resources :sessions, :only => [:new, :create]
    resources :registrations, :only => [:new, :create]
  end
  # 2- conferences and sessions
  # :as option for sessions is used to unclash name with devise url helper (session_path(resource_or_scope namely))
  resources :sessions, :except => [:new, :create], :as => :awesome_sessions do
    resources :ratings, :only => [:create, :update]
  end

  resources :registrations, :except => [:new, :create] do
    get :search, :on => :member
  end
  # assign registration
  put 'registrations/:registration_id/users/:user_id' => 'registrations#assign', :as => :assign_user_registration
  # pay invoice
  resources :invoices, only: [] do
    resources :payments, only: [:new, :create]
  end

  # admin interface
  namespace :admin do
    get '/' => 'admin#show'
    mount Resque::Server, at: '/jobs', as: :jobs
    resources :users, :only => [:index, :edit, :update]
    resources :registrations, :only => [:index]
  end

  # bug there as of 3.0.0, infered controller is 'accounts'
  resource :account, :only => [:edit, :update], :controller => 'account' do
    get '/sessions' => 'account#sessions'
    get '/registrations' => 'account#registrations'
  end

  # static pages rendered through home controller
  [:contact, :place, :program, :sponsors, :promote, :version].each do |s|
    get "#{s}" => "home\##{s}"
  end

  # old pages redirected
  match "/soon" => redirect("/program")
  match "/history" => redirect("/contact")

  root :to => 'conferences#recent'
end
