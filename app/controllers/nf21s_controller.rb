class Nf21sController < ApplicationController
  before_action :set_nf21, only: [:show, :edit, :update, :destroy]

  # GET /nf21s
  # GET /nf21s.json
  def index
    @nf21s = Nf21.all
  end

  # GET /nf21s/1
  # GET /nf21s/1.json
  def show
  end

  # GET /nf21s/new
  def new
    @nf21 = Nf21.new
  end

  # GET /nf21s/1/edit
  def edit
  end

  # POST /nf21s
  # POST /nf21s.json
  def create
    @nf21 = Nf21.new(nf21_params)

    respond_to do |format|
      if @nf21.save
        format.html { redirect_to @nf21, notice: 'Nf21 was successfully created.' }
        format.json { render :show, status: :created, location: @nf21 }
      else
        format.html { render :new }
        format.json { render json: @nf21.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nf21s/1
  # PATCH/PUT /nf21s/1.json
  def update
    respond_to do |format|
      if @nf21.update(nf21_params)
        format.html { redirect_to @nf21, notice: 'Nf21 was successfully updated.' }
        format.json { render :show, status: :ok, location: @nf21 }
      else
        format.html { render :edit }
        format.json { render json: @nf21.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nf21s/1
  # DELETE /nf21s/1.json
  def destroy
    @nf21.destroy
    respond_to do |format|
      format.html { redirect_to nf21s_url, notice: 'Nf21 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nf21
      @nf21 = Nf21.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def nf21_params
      params.require(:nf21).permit(:emissao, :date,, :numero, :integer,, :valor, :decimal,, :cadastro, :text,, :mestre, :text)
    end
end
