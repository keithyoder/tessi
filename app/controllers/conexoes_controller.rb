class ConexoesController < ApplicationController
  before_action :set_conexao, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /conexoes
  # GET /conexoes.json
  def index
    @q = Conexao.ransack(params[:q])
    @q.sorts = "pessoa_nome"
    @conexoes = @q.result.page params[:page]
  end

  def suspenso
    @q = Conexao.bloqueado.ransack(params[:q])
    @q.sorts = "ponto_id"
    @conexoes = @q.result.page params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data @conexoes.except(:limit, :offset).to_csv, filename: "suspensos-#{Date.today}.csv" }
    end
  end

  def integrar
    AtualizarRadiusJob.perform_later()
    respond_to do |format|
      format.html { redirect_to conexoes_url, notice: 'Integração Radius inicada.' }
      format.json { head :no_content }
    end
  end

  # GET /conexoes/1
  # GET /conexoes/1.json
  def show
    @conexao = Conexao.find(params[:id])
    @autenticacoes = @conexao.autenticacoes.order(authdate: :desc).page params[:page]
    @conexao_verificar_atributos = @conexao.conexao_verificar_atributos.order(:atributo)
    @conexao_enviar_atributos = @conexao.conexao_enviar_atributos.order(:atributo)
  end

  # GET /conexoes/new
  def new
    @conexao = Conexao.new
    if params[:pessoa_id]
      @conexao.pessoa_id = params[:pessoa_id]
    end
    @caixas = FibraCaixa.joins(:fibra_rede, :ponto).order("pontos.nome, fibra_caixas.nome").all
  end

  # GET /conexoes/1/edit
  def edit
    get_caixas
  end

  # POST /conexoes
  # POST /conexoes.json
  def create
    @conexao = Conexao.new(conexao_params)
    get_caixas
    respond_to do |format|
      if @conexao.save
        format.html { redirect_to @conexao, notice: "Conexao was successfully created." }
        format.json { render :show, status: :created, location: @conexao }
      else
        format.html { render :new }
        format.json { render json: @conexao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conexoes/1
  # PATCH/PUT /conexoes/1.json
  def update
    get_caixas
    respond_to do |format|
      if @conexao.update(conexao_params)
        format.html { redirect_to @conexao, notice: "Conexao was successfully updated." }
        format.json { render :show, status: :ok, location: @conexao }
      else
        format.html { render :edit }
        format.json { render json: @conexao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conexoes/1
  # DELETE /conexoes/1.json
  def destroy
    @conexao.destroy
    respond_to do |format|
      format.html { redirect_to conexoes_url, notice: "Conexao was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conexao
    @conexao = Conexao.find(params[:id])
  end

  def get_caixas
    @caixas = @conexao.ponto.caixas.joins(:fibra_rede, :ponto).order("pontos.nome, fibra_caixas.nome").all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def conexao_params
    params.require(:conexao).permit(:pessoa_id, :plano_id, :ponto_id, :ip, :velocidade, :bloqueado,
                                    :auto_bloqueio, :usuario, :senha, :observacao, :inadimplente,
                                    :tipo, :mac, :contrato_id, :caixa_id, :porta, :latitude, :longitude)
  end
end
