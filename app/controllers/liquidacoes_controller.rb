class LiquidacoesController < ApplicationController
    load_and_authorize_resource :fatura, :through => :liquidacoes 

  def index
    @liquidacoes = Fatura.select("date(liquidacao) as data, count(*) as liquidacoes, sum(valor_liquidacao) as valor")
        .where("liquidacao not null")
        .group(:liquidacao)
        .order(liquidacao: :desc)
        .page params[:page]
  end
    
  def show
    @liquidacoes = Fatura.where("liquidacao = ?", params[:id]).page params[:page]
  end

end
