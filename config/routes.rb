Rails.application.routes.draw do
  resources :servidores
  resources :logradouros
  resources :bairros
  resources :cidades
  devise_for :users
  resources :estados
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end
