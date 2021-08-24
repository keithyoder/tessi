class ContratosController < ApplicationController
  include ActionView::Helpers::NumberHelper
  load_and_authorize_resource
  before_action :set_contrato, only: %i[show edit update destroy renovar termo]

  # GET /contratos
  # GET /contratos.json
  def index
    contrato = Contrato.includes(:pessoa, :plano)
    contrato = contrato.ativos if params.key?(:ativos)
    contrato = contrato.renovaveis if params.key?(:renovaveis)
    contrato = contrato.suspendiveis if params.key?(:suspendiveis)
    contrato = contrato.cancelaveis if params.key?(:cancelaveis)
    contrato = contrato.fisica if params.key?(:fisica)
    contrato = contrato.juridica if params.key?(:juridica)
    contrato = contrato.novos_por_mes(params[:adesao]) if params.key?(:adesao)
    contrato = contrato.sem_conexao if params.key?(:sem_conexao)

    @params = params.permit(
      :ativos, :renovaveis, :suspendiveis, :cancelaveis, :fisica, :juridica,
      :adesao, :sem_conexao
    )
    @q = contrato.ransack(params[:q])
    @q.sorts = 'pessoa_nome'
    @contratos = @q.result.page params[:page]
    respond_to do |format|
      format.html
      format.csv do
        send_data(
          @contratos.except(:limit, :offset).to_csv,
          filename: "contratos-#{Date.today}.csv"
        )
      end
    end
  end

  def churn
    meses = Contrato
            .select("date_trunc('month', adesao) as mes, count(*) as adesoes, min(cancelamentos.quantos) as cancelamentos")
            .joins("LEFT JOIN (SELECT count(*) AS quantos, date_trunc('month', cancelamento) as mes FROM contratos WHERE cancelamento - adesao > 15 GROUP BY date_trunc('month', cancelamento)) cancelamentos ON date_trunc('month', adesao) = cancelamentos.mes")
            .group("date_trunc('month', adesao)")
            .where('adesao - cancelamento > 15 or cancelamento is null')
            .order("date_trunc('month', adesao) DESC")
    @q = meses.ransack
    @meses = @q.result.page params[:page]
  end

  def boletos
    result = []
    Brcobranca.configuration.gerador = :rghost_carne
    @contrato.faturas
             .where(liquidacao: nil)
             .where(vencimento: 1.day.ago..Date::Infinity.new)
             .order(:vencimento).each do |fatura|
      result << fatura.boleto
    end
    send_data Brcobranca::Boleto::Template::RghostCarne.lote_carne(result), :filename => 'boletos.pdf', :type => :pdf, :disposition => 'inline'
  end

  # GET /contratos/1
  # GET /contratos/1.json
  # GET /contratos/1.pdf
  def show
    @contrato = Contrato.find(params[:id])
    if request.format != :pdf
      @faturas = @contrato.faturas.order(parcela: :desc).page params[:page]
    end
    respond_to do |format|
      format.html { render :show }
      format.htm { render :termo }
    end
  end

  def termo
    respond_to do |format|
      format.html { render :termo }
    end
  end

  # GET /contratos/new
  def new
    @contrato = Contrato.new
    @contrato.pessoa_id = params[:pessoa_id] if params.key?(:pessoa_id)
    @contrato.valor_instalacao = 0
    @contrato.parcelas_instalacao = 0
    @contrato.primeiro_vencimento = 1.month.from_now
    @contrato.dia_vencimento = Date.today.day
  end

  # GET /contratos/1/edit
  def edit
  end

  def renovar
    @contrato.renovar
    respond_to do |format|
      format.html { redirect_to @contrato, notice: 'Contrato renovado com sucesso.' }
    end
  end

  # POST /contratos
  # POST /contratos.json
  def create
    @contrato = Contrato.new(contrato_params)

    respond_to do |format|
      if @contrato.save
        format.html { redirect_to @contrato, notice: 'Contrato criado com sucesso.' }
        format.json { render :show, status: :created, location: @contrato }
      else
        format.html { render :new }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratos/1
  # PATCH/PUT /contratos/1.json
  def update
    respond_to do |format|
      if @contrato.update(contrato_params)
        format.html { redirect_to @contrato, notice: 'Contrato atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @contrato }
      else
        format.html { render :edit }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratos/1
  # DELETE /contratos/1.json
  def destroy
    respond_to do |format|
      if @contrato.destroy
        format.html { redirect_to contratos_url, notice: 'Contrato excluido com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contrato
    @contrato = Contrato.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contrato_params
    params.require(:contrato).permit(
      :pessoa_id, :plano_id, :pagamento_perfil_id, :status, :dia_vencimento,
      :adesao, :valor_instalacao, :numero_conexoes, :cancelamento, :emite_nf,
      :primeiro_vencimento, :prazo_meses, :parcelas_instalacao
    )
  end
end
