Rails.application.routes.draw do

  post 'users', to: 'users#create'
  post 'auth/login', to: 'authentication#authenticate'

  resources :projects do
    resources :tasks do
      resources :comments do
        resources :comment_files
      end
    end
  end

end
