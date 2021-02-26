class AtendimentosController < ApplicationController
  before_action :set_atendimento, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /atendimentos or /atendimentos.json
  def index
    @q = Atendimento.ransack(params[:q])
    @atendimentos = @q.result(order: :created_at).page params[:page]
    respond_to do |format|
      format.html
    end
  end

  # GET /atendimentos/1 or /atendimentos/1.json
  def show
  end

  # GET /atendimentos/new
  def new
    @atendimento = Atendimento.new
    @detalhe = AtendimentoDetalhe.new atendimento: @atendimento
  end

  # GET /atendimentos/1/edit
  def edit
  end

  # POST /atendimentos or /atendimentos.json
  def create
    puts detalhe_params
    @atendimento = Atendimento.new(atendimento_params)
    @detalhe = AtendimentoDetalhe.new(
      {
        atendimento: @atendimento,
        atendente: current_user,
        tipo: AtendimentoDetalhe.tipos.key(atendimento_params[:detalhe_tipo].to_i),
        descricao: atendimento_params[:detalhe_descricao]
      }
    )
    respond_to do |format|
      if @atendimento.save && @detalhe.save
        format.html { redirect_to @atendimento, notice: 'Atendimento criado com sucesso.' }
        format.json { render :show, status: :created, location: @atendimento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atendimentos/1 or /atendimentos/1.json
  def update
    respond_to do |format|
      if @atendimento.update(atendimento_params)
        format.html { redirect_to @atendimento, notice: "Atendimento was successfully updated." }
        format.json { render :show, status: :ok, location: @atendimento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @atendimento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atendimentos/1 or /atendimentos/1.json
  def destroy
    @atendimento.destroy
    respond_to do |format|
      format.html { redirect_to atendimentos_url, notice: "Atendimento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_atendimento
    @atendimento = Atendimento.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def atendimento_params
    params.require(:atendimento).permit(
      :pessoa_id, :classificacao_id, :responsavel_id, :fechamento, :contrato_id,
      :conexao_id, :fatura_id, :detalhe_tipo, :detalhe_descricao
    )
  end

  def detalhe_params
    params.permit(:detalhe_tipo, :detalhe_descricao)
  end
end
