class FaturasController < ApplicationController
  load_and_authorize_resource
  before_action :set_fatura, only: [:show, :edit, :update, :destroy, :liquidacao, :boleto]

  # GET /faturas
  # GET /faturas.json
  def index
    if params.key?(:inadimplentes)
      @faturas = Fatura.inadimplentes.order(vencimento: :desc).page params[:page]
    elsif params.key?(:suspensos)
      @faturas = Fatura.suspensos.order(vencimento: :desc).page params[:page]
    else
      @faturas = Fatura.all.order(vencimento: :desc).page params[:page]
    end
  end

  # GET /faturas/1
  # GET /faturas/1.json
  def show
  end

  # GET /faturas/new
  def new
    @fatura = Fatura.new
  end

  # GET /faturas/1/edit
  def edit
  end

  def liquidacao
    respond_to do |format|
      format.html { render :liquidacao }
      format.json { render json: @fatura.errors, status: :unprocessable_entity }
    end
  end

  def boleto
    send_data @fatura.boleto.to(:pdf), :filename => "boleto.pdf", :type => :pdf
  end

  # POST /faturas
  # POST /faturas.json
  def create
    @fatura = Fatura.new(fatura_params)

    respond_to do |format|
      if @fatura.save
        format.html { redirect_to @fatura, notice: "Fatura was successfully created." }
        format.json { render :show, status: :created, location: @fatura }
      else
        format.html { render :new }
        format.json { render json: @fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /faturas/1
  # PATCH/PUT /faturas/1.json
  def update
    respond_to do |format|
      if @fatura.update(fatura_params)
        format.html { redirect_to @fatura, notice: "Fatura was successfully updated." }
        format.json { render :show, status: :ok, location: @fatura }
      else
        format.html { render :edit }
        format.json { render json: @fatura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faturas/1
  # DELETE /faturas/1.json
  def destroy
    @fatura.destroy
    respond_to do |format|
      format.html { redirect_to faturas_url, notice: "Fatura was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fatura
    @fatura = Fatura.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def fatura_params
    params.require(:fatura).permit(:contrato_id, :valor, :vencimento, :nossonumero, :parcela,
                                   :arquivo_remessa, :data_remessa, :data_cancelamento, :meio_liquidacao, :valor_liquidacao, :liquidacao)
  end
end
