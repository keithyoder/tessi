class LiquidacoesController < ApplicationController
    load_and_authorize_resource :fatura, :through => :liquidacoes 

  def index
    @liquidacoes = Fatura.select("liquidacao as data, count(*) as liquidacoes, sum(valor_liquidacao) as valor").group(:liquidacao).order(liquidacao: :desc).page params[:page]
  end
    
end
