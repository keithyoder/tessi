class FaturasController < ApplicationController
  load_and_authorize_resource
  before_action :set_fatura, only: [:show, :edit, :update, :destroy, :liquidacao, :boleto]

  # GET /faturas
  # GET /faturas.json
  def index
    if params.key?(:inadimplentes)
      @faturas = Fatura.inadimplentes.order(vencimento: :desc).page params[:page]
    elsif params.key?(:suspensos)
      @faturas = Fatura.suspensos.order(vencimento: :desc).page params[:page]
    else
      @faturas = Fatura.all.order(vencimento: :desc).page params[:page]
    end
  end

  # GET /faturas/1
  # GET /faturas/1.json
  def show
  end

  # GET /faturas/new
  def new
    @fatura = Fatura.new
  end

  # GET /faturas/1/edit
  def edit
  end

  def liquidacao
    respond_to do |format|
      format.html { render :liquidacao }
      format.json { render json: @fatura.errors, status: :unprocessable_entity }
    end
  end

  def boleto
    @boleto = Brcobranca::Boleto::Santander.new
    @boleto.convenio = "1238798"
    @boleto.cedente = "Alipio Barbosa"
    @boleto.documento_cedente = "12345678912"
    @boleto.sacado = @fatura.pessoa.nome
    @boleto.sacado_documento = @fatura.pessoa.cpf
    @boleto.valor = @fatura.valor
    @boleto.agencia = "4042"
    @boleto.conta_corrente = "61900"
    @boleto.variacao = "19"
    @boleto.nosso_numero = "111"
    @boleto.data_vencimento = @fatura.vencimento
    @boleto.instrucao1 = "Pagável na rede bancária até a data de vencimento."
    @boleto.instrucao2 = "Juros de mora de 2.0% mensal(R$ 0,09 ao dia)"
    @boleto.instrucao3 = "DESCONTO DE R$ 29,50 APÓS 05/11/2006 ATÉ 15/11/2006"
    @boleto.instrucao4 = "NÃO RECEBER APÓS 15/11/2006"
    @boleto.instrucao5 = "Após vencimento pagável somente nas agências do Banco do Brasil"
    @boleto.instrucao6 = "ACRESCER R$ 4,00 REFERENTE AO BOLETO BANCÁRIO"
    @boleto.sacado_endereco = "Av. Rubéns de Mendonça, 157 - 78008-000 - Cuiabá/MT"
    @boleto.cedente_endereco = "Av. Rubéns de Mendonça, 1000 - 78008-000 - Cuiabá/MT"
    headers['Content-Type'] = 'application/pdf'
    send_data @boleto.to(:pdf), :filename => "boleto_santander.pdf"
  end

  # POST /faturas
  # POST /faturas.json
  def create
    @fatura = Fatura.new(fatura_params)

    respond_to do |format|
      if @fatura.save
        format.html { redirect_to @fatura, notice: 'Fatura was successfully created.' }
        format.json { render :show, status: :created, location: @fatura }
      else
        format.html { render :new }
        format.json { render json: @fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /faturas/1
  # PATCH/PUT /faturas/1.json
  def update
    respond_to do |format|
      if @fatura.update(fatura_params)
        format.html { redirect_to @fatura, notice: 'Fatura was successfully updated.' }
        format.json { render :show, status: :ok, location: @fatura }
      else
        format.html { render :edit }
        format.json { render json: @fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faturas/1
  # DELETE /faturas/1.json
  def destroy
    @fatura.destroy
    respond_to do |format|
      format.html { redirect_to faturas_url, notice: 'Fatura was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fatura
      @fatura = Fatura.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fatura_params
      params.require(:fatura).permit(:contrato_id, :valor, :vencimento, :nossonumero, :parcela,
        :arquivo_remessa, :data_remessa, :data_cancelamento, :meio_liquidacao, :valor_liquidacao, :liquidacao)
    end
end
