Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users, only: [:create]
  post "/login", to: "users#login"
  resource :posts, only: [:create]
  post "/posts/update", to: "posts#update"
  post "/posts/delete", to: "posts#delete"
  get "/posts", to: "posts#get"

  resource :comments, only: [:create]
  post "/comments/update", to: "comments#update"
  post "/comments/delete", to: "comments#delete"

end
