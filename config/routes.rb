Rails.application.routes.draw do
  resources :liquidacoes
  resources :faturas do
    get :liquidacao, :on => :member
  end
  resources :contratos
  resources :conexao_enviar_atributos
  resources :conexao_verificar_atributos
  resources :conexoes do
    get :suspenso, :on => :collection
  end
  resources :pessoas do
    get :autocomplete_logradouro_nome, :on => :collection
  end
  resources :plano_enviar_atributos
  resources :plano_verificar_atributos
  resources :pontos do
    get :snmp, :on => :collection
  end
  resources :planos
  resources :servidores do
    get :backup, :on => :member
    get :backups, :on => :collection
  end
  resources :logradouros
  resources :bairros
  resources :cidades do
    get :sici, :on => :collection
  end
  devise_for :users
  resources :estados
  resources :token
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end
