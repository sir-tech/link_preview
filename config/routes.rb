Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'image_dimension', to: 'home#image_dimension'
  get 'link_check', to: 'home#link_check'
  root to: 'home#index'
end
