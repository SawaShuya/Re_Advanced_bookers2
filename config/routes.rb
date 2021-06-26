Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    get 'followings' => 'relationships#following'
    get 'followed' => 'relationships#followed'
    resource :relationships, only: [:create, :destroy]
    get 'rooms' => 'rooms#chat_rooms'
  end
  post 'users/:id/book_count' => 'users#book_count', as: 'book_count'
  
  post 'search' => 'search#search', as: 'search'
  
  post 'dm/:id' => 'rooms#create_dm', as: 'start_dm'
  
  resources :rooms, only: [:index, :create, :show, :new, :edit, :update] do
    get 'detail' => 'rooms#detail', as: 'detail'
    get 'new_email' => 'rooms#new_email', as: 'new_email'
    post 'send_email' => 'rooms#send_email', as: 'send_email'
    resource :room_users, only: [:create, :destroy]
  end
  resources :chats, only: [:create, :index]
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
end
