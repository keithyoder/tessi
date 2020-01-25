class ConexaoEnviarAtributosController < ApplicationController
  before_action :set_conexao_enviar_atributo, only: [:show, :edit, :update, :destroy]

  # GET /conexao_enviar_atributos
  # GET /conexao_enviar_atributos.json
  def index
    @conexao_enviar_atributos = ConexaoEnviarAtributo.all
  end

  # GET /conexao_enviar_atributos/1
  # GET /conexao_enviar_atributos/1.json
  def show
  end

  # GET /conexao_enviar_atributos/new
  def new
    @conexao_enviar_atributo = ConexaoEnviarAtributo.new
  end

  # GET /conexao_enviar_atributos/1/edit
  def edit
  end

  # POST /conexao_enviar_atributos
  # POST /conexao_enviar_atributos.json
  def create
    @conexao_enviar_atributo = ConexaoEnviarAtributo.new(conexao_enviar_atributo_params)

    respond_to do |format|
      if @conexao_enviar_atributo.save
        format.html { redirect_to @conexao_enviar_atributo, notice: 'Conexao enviar atributo was successfully created.' }
        format.json { render :show, status: :created, location: @conexao_enviar_atributo }
      else
        format.html { render :new }
        format.json { render json: @conexao_enviar_atributo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conexao_enviar_atributos/1
  # PATCH/PUT /conexao_enviar_atributos/1.json
  def update
    respond_to do |format|
      if @conexao_enviar_atributo.update(conexao_enviar_atributo_params)
        format.html { redirect_to @conexao_enviar_atributo, notice: 'Conexao enviar atributo was successfully updated.' }
        format.json { render :show, status: :ok, location: @conexao_enviar_atributo }
      else
        format.html { render :edit }
        format.json { render json: @conexao_enviar_atributo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conexao_enviar_atributos/1
  # DELETE /conexao_enviar_atributos/1.json
  def destroy
    @conexao_enviar_atributo.destroy
    respond_to do |format|
      format.html { redirect_to conexao_enviar_atributos_url, notice: 'Conexao enviar atributo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conexao_enviar_atributo
      @conexao_enviar_atributo = ConexaoEnviarAtributo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conexao_enviar_atributo_params
      params.require(:conexao_enviar_atributo).permit(:conexao_id, :atributo, :op, :valor)
    end
end
