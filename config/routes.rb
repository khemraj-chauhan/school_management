Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#home"

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :schools do
    resources :courses
  end

  resources :batches

  resources :student_batches do
    collection do
      post :enrollment_request
    end
  end
end
