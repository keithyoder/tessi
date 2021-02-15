class OsController < ApplicationController
  before_action :set_os, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /os or /os.json
  def index
    @os = Os.all
    @q = Os.ransack(params[:q])
    @os = @q.result(order: :created_at).page params[:page]
    respond_to do |format|
      format.html
    end
  end

  # GET /os/1 or /os/1.json
  def show
  end

  # GET /os/new
  def new
    @os = Os.new
    @os.aberto_por = @current_user
    @os.responsavel = @current_user
  end

  # GET /os/1/edit
  def edit
  end

  # POST /os or /os.json
  def create
    @os = Os.new(os_params)

    respond_to do |format|
      if @os.save
        format.html { redirect_to @os, notice: "OS criado com sucesso." }
        format.json { render :show, status: :created, location: @os }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @os.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /os/1 or /os/1.json
  def update
    respond_to do |format|
      if @os.update(os_params)
        format.html { redirect_to @os, notice: "Os was successfully updated." }
        format.json { render :show, status: :ok, location: @os }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @os.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /os/1 or /os/1.json
  def destroy
    @os.destroy
    respond_to do |format|
      format.html { redirect_to os_index_url, notice: "Os was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_os
    @os = Os.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def os_params
    params.require(:os).permit(:tipo, :classificacao_id, :pessoa_id, :conexao_id, :aberto_por_id, :responsavel_id, :tecnico_1_id, :tecnico_2_id, :fechamento, :descricao, :encerramento)
  end
end
