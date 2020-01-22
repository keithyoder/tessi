Rails.application.routes.draw do
  resources :plano_enviar_atributos
  resources :plano_verificar_atributos
  resources :pontos
  resources :planos
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
