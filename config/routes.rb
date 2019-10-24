Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "pages#home", as: "root"
  get "/milkshakes", to: "milkshakes#index", as: "milkshakes"
  post "/milkshakes", to: "milkshakes#create"
  get "/milkshakes/new", to: "milkshakes#new", as: "new_milkshake"
  get "/milkshakes/:id", to: "milkshakes#show", as: "milkshake"
  patch "/milkshakes/:id", to: "milkshakes#update"
  get "/milkshakes/:id/edit", to: "milkshakes#edit", as: "edit_milkshake"
  get "/payment/success", to: "payments#success", as: "success_payment"
  post "/payment/webhook", to: "payments#webhook", as: "webhook_payment"
end
