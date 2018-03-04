require 'api_version_constraint'

Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: "/" do
    # Version 01
    namespace :v1, path: "/", constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :users, only: [:show]
    end

    # # Version 02
    # namespace :v2, path: "/", constraints: ApiVersionConstraint.new(version: 2, default: true) do
    #   resources :tasks
    # end
  end
end
