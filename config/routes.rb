ConferenceOnRails::Application.routes.draw do
  # 1- devise
  devise_for :users
  
  # 2- conferences and sessions 
  # !!! watch out !!! session resources redefine session_path, defined first in Devise::Controllers::UrlHelpers)
  resources :sessions, :except => [:new, :create]
  resources :conferences  do
    resources :sessions, :only => [:new, :create]
  end
  resources :place

  # admin interface
  get '/admin' => 'admin#show'
  namespace :admin do
    resources :users, :only => [:edit, :update]
  end

  # bug there as of 3.0.0, infered controller is 'accounts'
  resource :account, :only => [:edit, :update], :controller => 'account'

  root :to => 'home#index'
end
