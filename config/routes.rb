Rails.application.routes.draw do
  resources :boards, param: :short_name
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
