Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'image_dimension', to: 'home#image_dimension'
  root to: 'home#index'
end
