Rails.application.routes.draw do
  resources :equipamentos
  get 'sac/inadimplencia'
  get 'sac/suspensao'
  resources :atendimento_detalhes, only: [:new, :create, :index]
  resources :atendimentos do
    get :encerrar, on: :member
  end
  resources :os
  resources :classificacoes
  resources :clasificacoes
  resources :excecoes
  resources :ip_redes
  resources :nf21s do
    get 'competencia/:mes', action: :competencia, as: :competencia, on: :collection    
  end
  resources :fibra_caixas
  resources :fibra_redes
  resources :retornos
  resources :pagamento_perfis do
    get 'remessa/:sequencia', action: :remessa, as: :remessa, on: :member
  end
  resources :liquidacoes
  resources :faturas do
    get :liquidacao, on: :member
    get :boleto, on: :member
    get :estornar, on: :member
    get :cancelar, on: :member
    get :gerar_nf, on: :member
  end
  resources :contratos do
    get :boletos, on: :member
    get :renovar, on: :member
  end
  resources :conexoes do
    get :suspenso, on: :collection
    get :integrar, on: :collection
  end
  resources :pessoas do
    get :autocomplete_logradouro_nome, on: :collection
  end
  resources :plano_enviar_atributos
  resources :plano_verificar_atributos
  resources :pontos do
    get :snmp, on: :collection
  end
  resources :planos
  resources :servidores do
    get :backup, on: :member
    get :backups, on: :collection
  end
  resources :logradouros
  resources :bairros
  resources :cidades do
    get :sici, on: :collection
  end
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                     }
  resources :estados
  resources :token
  resources :settings
  get "welcome/index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
end
