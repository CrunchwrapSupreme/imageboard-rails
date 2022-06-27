Rails.application.routes.draw do
  resources :boards, param: :short_name do
    resources :comment_threads, only: [:show, :create, :destroy], path: 'threads' do
      shallow { resources :comments, only: [:destroy, :create] }
    end
  end

  devise_for :users, skip: [:registrations]
  devise_scope :user do
    get    'sign_in',  to: 'users/sessions#new'
    delete 'sign_out', to: 'users/sessions#destroy'
  end

  root 'boards#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
