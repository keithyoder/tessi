class PagamentoPerfisController < ApplicationController
  load_and_authorize_resource
  before_action :set_pagamento_perfil, only: [:show, :edit, :update, :destroy, :remessa]

  # GET /pagamento_perfis
  # GET /pagamento_perfis.json
  def index
    @pagamento_perfis = PagamentoPerfil.order("nome").all
  end

  # GET /pagamento_perfis/1
  # GET /pagamento_perfis/1.json
  def show
    @retornos = @pagamento_perfil.retornos.order(data: :desc).page params[:page]
  end

  # GET /pagamento_perfis/new
  def new
    @pagamento_perfil = PagamentoPerfil.new
  end

  # GET /pagamento_perfis/1/edit
  def edit
  end

  def remessa
    faturas = @pagamento_perfil.faturas
                               .eager_load(%i[pessoa logradouro bairro cidade estado plano])
                               .where.not(nossonumero: '')
    if params.key?(:baixas)
      faturas = faturas.where()
        .where(vencimento: 10.days.ago..30.days.from_now)
        .where.not(liquidacao: nil)
        .where.not(registro_id: nil)
        .where(retorno_id: nil, baixa_id: nil)
    else
      faturas = faturas.where(
        vencimento: Date.today..30.days.from_now,
        liquidacao: nil,
        registro_id: nil
      )
    end
    send_data(
      @pagamento_perfil.remessa(faturas.map(&:remessa)).gera_arquivo,
      content_type: 'text/plain',
      filename: 'remessa.txt'
    )
  end

  # POST /pagamento_perfis
  # POST /pagamento_perfis.json
  def create
    @pagamento_perfil = PagamentoPerfil.new(pagamento_perfil_params)

    respond_to do |format|
      if @pagamento_perfil.save
        format.html { redirect_to @pagamento_perfil, notice: "Pagamento perfil was successfully created." }
        format.json { render :show, status: :created, location: @pagamento_perfil }
      else
        format.html { render :new }
        format.json { render json: @pagamento_perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagamento_perfis/1
  # PATCH/PUT /pagamento_perfis/1.json
  def update
    respond_to do |format|
      if @pagamento_perfil.update(pagamento_perfil_params)
        format.html { redirect_to @pagamento_perfil, notice: "Pagamento perfil was successfully updated." }
        format.json { render :show, status: :ok, location: @pagamento_perfil }
      else
        format.html { render :edit }
        format.json { render json: @pagamento_perfil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagamento_perfis/1
  # DELETE /pagamento_perfis/1.json
  def destroy
    @pagamento_perfil.destroy
    respond_to do |format|
      format.html { redirect_to pagamento_perfis_url, notice: "Pagamento perfil was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pagamento_perfil
    @pagamento_perfil = PagamentoPerfil.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pagamento_perfil_params
    params.require(:pagamento_perfil).permit(:nome, :tipo, :cedente, :agencia, :conta, :carteira, :banco)
  end
end
