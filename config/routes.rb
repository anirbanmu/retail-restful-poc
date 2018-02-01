Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/products/:id', to: 'products#fetch', as: :product
  put '/products/:id', to: 'products#update', as: :update_product
end
