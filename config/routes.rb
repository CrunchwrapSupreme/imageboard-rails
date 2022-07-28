Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all

  root 'boards#index'

  resources :boards, param: :short_name do
    resources :comment_threads, only: %i[show create destroy], path: 'threads' do
      shallow { resources :comments, only: %i[destroy create] }
      member do
        put :lock
        put :unlock
      end
    end
  end

  devise_for :users, skip: [:registrations]
  devise_scope :user do
    get    'sign_in',  to: 'users/sessions#new'
    delete 'sign_out', to: 'users/sessions#destroy'
  end

  authenticate :user, ->(user) { user.min_role?(:owner) } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
