class RetornosController < ApplicationController
  load_and_authorize_resource
  before_action :set_retorno, only: [:show, :edit, :update, :destroy]

  # GET /retornos
  # GET /retornos.json
  def index
    @retornos = Retorno.all
  end

  # GET /retornos/1
  # GET /retornos/1.json
  def show
    @faturas = Fatura.where(pagamento_perfil: @retorno.pagamento_perfil)
    @linhas = Brcobranca::Retorno::Cnab240::Santander.load_lines ActiveStorage::Blob.service.path_for(@retorno.arquivo.key)
  end

  # GET /retornos/new
  def new
    @retorno = Retorno.new
  end

  # GET /retornos/1/edit
  def edit
  end

  # POST /retornos
  # POST /retornos.json
  def create
    @retorno = Retorno.new(retorno_params)

    respond_to do |format|
      if @retorno.save
        format.html { redirect_to @retorno, notice: "Retorno was successfully created." }
        format.json { render :show, status: :created, location: @retorno }
      else
        format.html { render :new }
        format.json { render json: @retorno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /retornos/1
  # PATCH/PUT /retornos/1.json
  def update
    Brcobranca::Retorno::Cnab240::Santander.load_lines(ActiveStorage::Blob.service.path_for(@retorno.arquivo.key)).each do |linha|
      fatura = Fatura.where(pagamento_perfil: @retorno.pagamento_perfil, nossonumero: linha.nosso_numero[0...-1]).first
      if fatura
        fatura.attributes = {
          liquidacao: cnab_data(linha.data_ocorrencia),
          juros_cobrado: cnab_float(linha.juros_mora),
          banco: linha.banco_recebedor,
          agencia: linha.agencia_recebedora_com_dv[0...-1],
          valor_liquidacao: cnab_float(linha.valor_recebido),
        }
        fatura.save
      end
    end
    respond_to do |format|
      format.html { redirect_to @retorno, notice: "Retorno was successfully updated." }
      format.json { render :show, status: :ok, location: @retorno }
    end
  end

  # DELETE /retornos/1
  # DELETE /retornos/1.json
  def destroy
    @retorno.destroy
    respond_to do |format|
      format.html { redirect_to retornos_url, notice: "Retorno was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_retorno
    @retorno = Retorno.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def retorno_params
    params.require(:retorno).permit(:pagamento_perfil_id, :data, :sequencia, :arquivo)
  end
end
