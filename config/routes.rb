Rails.application.routes.draw do

  # Optionally set the locale in URL
  scope "(:locale)", locale: /de|en/ do

    # Users
    resources :users do
      get 'new_valid_email_request', on: :member
    end

    # Session handling
    post 'sessions' => 'sessions#signin'
    delete 'sessions' => 'sessions#signout'

    # Valid email request handler
    resources :valid_email_requests, only: [] do
      get 'confirm', on: :member
    end

    # Reset password request handler
    resources :reset_password_requests, only: [:create, :edit, :update]

    # Explicit root
    get 'start' => 'application#start'
    get 'dashboard' => 'application#dashboard'

  end

  # You can have the root of your site routed with "root"
  get '/:locale' => 'application#start'
  root 'application#start'

end
