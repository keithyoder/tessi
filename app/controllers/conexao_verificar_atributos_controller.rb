class ConexaoVerificarAtributosController < ApplicationController
  before_action :set_conexao_verificar_atributo, only: [:show, :edit, :update, :destroy]

  # GET /conexao_verificar_atributos
  # GET /conexao_verificar_atributos.json
  def index
    @conexao_verificar_atributos = ConexaoVerificarAtributo.all
  end

  # GET /conexao_verificar_atributos/1
  # GET /conexao_verificar_atributos/1.json
  def show
  end

  # GET /conexao_verificar_atributos/new
  def new
    @conexao_verificar_atributo = ConexaoVerificarAtributo.new
  end

  # GET /conexao_verificar_atributos/1/edit
  def edit
  end

  # POST /conexao_verificar_atributos
  # POST /conexao_verificar_atributos.json
  def create
    @conexao_verificar_atributo = ConexaoVerificarAtributo.new(conexao_verificar_atributo_params)

    respond_to do |format|
      if @conexao_verificar_atributo.save
        format.html { redirect_to @conexao_verificar_atributo, notice: 'Conexao verificar atributo was successfully created.' }
        format.json { render :show, status: :created, location: @conexao_verificar_atributo }
      else
        format.html { render :new }
        format.json { render json: @conexao_verificar_atributo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conexao_verificar_atributos/1
  # PATCH/PUT /conexao_verificar_atributos/1.json
  def update
    respond_to do |format|
      if @conexao_verificar_atributo.update(conexao_verificar_atributo_params)
        format.html { redirect_to @conexao_verificar_atributo, notice: 'Conexao verificar atributo was successfully updated.' }
        format.json { render :show, status: :ok, location: @conexao_verificar_atributo }
      else
        format.html { render :edit }
        format.json { render json: @conexao_verificar_atributo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conexao_verificar_atributos/1
  # DELETE /conexao_verificar_atributos/1.json
  def destroy
    @conexao_verificar_atributo.destroy
    respond_to do |format|
      format.html { redirect_to conexao_verificar_atributos_url, notice: 'Conexao verificar atributo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conexao_verificar_atributo
      @conexao_verificar_atributo = ConexaoVerificarAtributo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conexao_verificar_atributo_params
      params.require(:conexao_verificar_atributo).permit(:conexao_id, :atributo, :op, :valor)
    end
end
