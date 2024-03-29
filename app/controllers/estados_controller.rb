# frozen_string_literal: true

class EstadosController < ApplicationController
  load_and_authorize_resource
  before_action :set_estado, only: %i[show edit update destroy]

  # GET /estados
  # GET /estados.json
  def index
    @q = Estado.ransack(params[:q])
    @estados = @q.result(order: :nome).page params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data @estados.except(:limit, :offset).to_csv, filename: "estados-#{Date.today}.csv" }
    end
  end

  # GET /estados/1
  # GET /estados/1.json
  def show
    @estado = Estado.find(params[:id])
    @q = @estado.cidades.ransack(params[:q])
    @q.sorts = 'nome'
    @cidades = @q.result.page params[:page]
  end

  # GET /estados/new
  def new
    @estado = Estado.new
  end

  # GET /estados/1/edit
  def edit; end

  # POST /estados
  # POST /estados.json
  def create
    @estado = Estado.new(estado_params)

    respond_to do |format|
      if @estado.save
        format.html { redirect_to @estado, notice: 'Estado criado com sucesso.' }
        format.json { render :show, status: :created, location: @estado }
      else
        format.html { render :new }
        format.json { render json: @estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estados/1
  # PATCH/PUT /estados/1.json
  def update
    respond_to do |format|
      if @estado.update(estado_params)
        format.html { redirect_to @estado, notice: 'Estado was successfully updated.' }
        format.json { render :show, status: :ok, location: @estado }
      else
        format.html { render :edit }
        format.json { render json: @estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estados/1
  # DELETE /estados/1.json
  def destroy
    @estado.destroy
    respond_to do |format|
      format.html { redirect_to estados_url, notice: 'Estado was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_estado
    @estado = Estado.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def estado_params
    params.require(:estado).permit(:sigla, :nome, :ibge)
  end
end
