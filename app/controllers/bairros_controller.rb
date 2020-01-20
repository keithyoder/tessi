class BairrosController < ApplicationController
  before_action :set_bairro, only: [:show, :edit, :update, :destroy]

  # GET /bairros
  # GET /bairros.json
  def index
    @q = Bairro.ransack(params[:q])
    @bairros = @q.result(order: :nome).page params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data @bairros.except(:limit, :offset).to_csv, filename: "bairros-#{Date.today}.csv" }
    end
  end

  # GET /bairros/1
  # GET /bairros/1.json
  def show
    @bairro=Bairro.find(params[:id])
    @q = @bairro.logradouros.ransack(params[:q])
    @q.sorts = "nome"
    @logradouros = @q.result.page params[:page]
  end

  # GET /bairros/new
  def new
    @bairro = Bairro.new
  end

  # GET /bairros/1/edit
  def edit
  end

  # POST /bairros
  # POST /bairros.json
  def create
    @bairro = Bairro.new(bairro_params)

    respond_to do |format|
      if @bairro.save
        format.html { redirect_to @bairro, notice: 'Bairro was successfully created.' }
        format.json { render :show, status: :created, location: @bairro }
      else
        format.html { render :new }
        format.json { render json: @bairro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bairros/1
  # PATCH/PUT /bairros/1.json
  def update
    respond_to do |format|
      if @bairro.update(bairro_params)
        format.html { redirect_to @bairro, notice: 'Bairro was successfully updated.' }
        format.json { render :show, status: :ok, location: @bairro }
      else
        format.html { render :edit }
        format.json { render json: @bairro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bairros/1
  # DELETE /bairros/1.json
  def destroy
    @bairro.destroy
    respond_to do |format|
      format.html { redirect_to bairros_url, notice: 'Bairro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bairro
      @bairro = Bairro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bairro_params
      params.require(:bairro).permit(:nome, :cidade_id, :latitude, :longitude)
    end
end
