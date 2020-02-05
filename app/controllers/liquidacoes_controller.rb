class LiquidacoesController < ApplicationController
    load_and_authorize_resource :fatura, :through => :liquidacoes 

  def index
    @liquidacoes = Fatura.select("min(liquidacao) as data, count(*) as liquidacoes, sum(valor_liquidacao) as valor")
        .where("not liquidacao is null")
        .order(liquidacao: :desc)
    if params.key?(:ano)
        @liquidacoes = @liquidacoes.group("strftime('%Y', liquidacao)")
    else    
        @liquidacoes = @liquidacoes.group(:liquidacao)
    end
    @liquidacoes.page params[:page]
  end
    
  def show
    @liquidacoes = Fatura.where("liquidacao = ?", params[:id])
    if params.key?(:meio)
        @liquidacoes = @liquidacoes.where('meio_liquidacao = ?', params[:meio])
    end
    @liquidacoes = @liquidacoes.page params[:page]
  end

end
