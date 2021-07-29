class PontosController < ApplicationController
  before_action :set_ponto, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /pontos
  # GET /pontos.json
  def index
    @q = Ponto.ransack(params[:q])
    @q.sorts = "nome"
    @pontos = @q.result.page params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data @pontos.except(:limit, :offset).to_csv, filename: "pontos-#{Date.today}.csv" }
    end
  end

  def snmp
    AtualizarConcentradoresEPontosJob.perform_later()
    respond_to do |format|
      format.html { redirect_to pontos_url, notice: 'Varredura SNMP inicada.' }
      format.json { head :no_content }
    end
  end

  # GET /pontos/1
  # GET /pontos/1.json
  def show
    @q = @ponto.conexoes.ransack(params[:q])
    @q.sorts = "ip"
    @conexoes = @q.result.page params[:page]
    @autenticacoes = @ponto.autenticacoes
    if params.has_key?(:ips)
      @ips = @ponto.ips_disponiveis
    end
    @params = params.permit(
      :tab, :sem_autenticar, :suspensas, :ativas, :conectadas, :desconectadas,
      :sem_contrato
    )
    respond_to do |format|
      format.html # show.html.erb
      if params.has_key?(:ips)
        format.json { render json: @ips }
      else
        format.json
      end
    end
  end

  # GET /pontos/new
  def new
    @ponto = Ponto.new
  end

  # GET /pontos/1/edit
  def edit
  end

  # POST /pontos
  # POST /pontos.json
  def create
    @ponto = Ponto.new(ponto_params)

    respond_to do |format|
      if @ponto.save
        format.html { redirect_to @ponto, notice: 'Ponto was successfully created.' }
        format.json { render :show, status: :created, location: @ponto }
      else
        format.html { render :new }
        format.json { render json: @ponto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pontos/1
  # PATCH/PUT /pontos/1.json
  def update
    respond_to do |format|
      if @ponto.update(ponto_params)
        format.html { redirect_to @ponto, notice: 'Ponto was successfully updated.' }
        format.json { render :show, status: :ok, location: @ponto }
      else
        format.html { render :edit }
        format.json { render json: @ponto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pontos/1
  # DELETE /pontos/1.json
  def destroy
    @ponto.destroy
    respond_to do |format|
      format.html { redirect_to pontos_url, notice: 'Ponto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_ponto
    @ponto = Ponto.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ponto_params
    params.require(:ponto).permit(:nome, :sistema, :tecnologia, :servidor_id, :ip, :usuario, :senha, :equipamento)
  end
end
