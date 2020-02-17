class FaturasController < ApplicationController
  include ActionView::Helpers::NumberHelper
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
    @boleto.convenio = @fatura.pagamento_perfil.cedente
    @boleto.cedente = "Tessi - Serviços em Telecomunicações Ltda"
    @boleto.documento_cedente = '07.159.053/0001-07'
    @boleto.sacado = @fatura.pessoa.nome
    @boleto.sacado_documento = @fatura.pessoa.cpf
    @boleto.valor = @fatura.valor
    @boleto.agencia = @fatura.pagamento_perfil.agencia
    @boleto.conta_corrente = @fatura.pagamento_perfil.conta
    @boleto.variacao = @fatura.pagamento_perfil.carteira
    @boleto.nosso_numero = @fatura.nossonumero
    @boleto.data_vencimento = @fatura.vencimento
    @boleto.instrucao1 = "Desconto de #{number_to_currency(@fatura.contrato.plano.desconto)} para pagamento até o dia #{l(@fatura.vencimento)}"
    @boleto.instrucao2 = "Mensalidade de Internet - SCM - Plano: #{@fatura.contrato.plano.nome}"
    @boleto.instrucao3 = "Período de referência: #{l(@fatura.periodo_inicio)} - #{l(@fatura.periodo_fim)}}"
    @boleto.instrucao4 = "Após o vencimento cobrar multa de 2% e juros de 1% ao mês (pro rata die)"
    @boleto.instrucao5 = "S.A.C 0800-725-2129 - sac.tessi.com.br"
    @boleto.instrucao6 = "Central de Atendimento da Anatel 1331 ou 1332 para Deficientes Auditivos."
    @boleto.sacado_endereco = @fatura.pessoa.endereco + ' - ' + @fatura.pessoa.bairro.nome_cidade_uf
    @boleto.cedente_endereco = "Rua Treze de Maio, 5B - Centro - Pesqueira - PE 55200-000"
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
