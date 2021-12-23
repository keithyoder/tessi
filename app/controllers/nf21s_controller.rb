# frozen_string_literal: true

require 'stringio'

class Nf21sController < ApplicationController
  before_action :set_nf21, only: %i[show edit update destroy]
  load_and_authorize_resource

  # GET /nf21s
  # GET /nf21s.json
  def index
    @nf21s = Nf21.all
  end

  # GET /nf21s/1
  # GET /nf21s/1.json
  def show
    respond_to do |format|
      format.pdf { render :nf }
    end
  end

  # GET /nf21s/new
  def new
    @nf21 = Nf21.new
  end

  # GET /nf21s/1/edit
  def edit; end

  def competencia
    cadastro = StringIO.new
    mestre = StringIO.new
    itens = StringIO.new
    cadastro.set_encoding('iso-8859-14')
    mestre.set_encoding('iso-8859-14')
    itens.set_encoding('iso-8859-14')
    Nf21.competencia(params[:mes]).order(:numero).each do |nf|
      cadastro << nf.cadastro
      mestre << nf.mestre
      nf.nf21_itens.each do |item|
        itens << item.item
      end
    end
    cadastro.rewind
    mestre.rewind
    itens.rewind
    zipio = Zip::OutputStream.write_buffer do |zio|
      zio.put_next_entry(nome_arquivo(params[:mes], 'D'))
      zio.write cadastro.read
      zio.put_next_entry(nome_arquivo(params[:mes], 'M'))
      zio.write mestre.read
      zio.put_next_entry(nome_arquivo(params[:mes], 'I'))
      zio.write itens.read
    end
    zipio.rewind
    send_data(
      zipio.sysread,
      content_type: 'application/zip',
      disposition: 'attachment',
      filename: "competencia-#{params[:mes]}.zip"
    )
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
    params.require(:nf21).permit(:emissao, :numero, :valor, :cadastro, :mestre)
  end

  def nome_arquivo(mes, letra)
    "PE#{Setting.cnpj}21U  #{mes[2..3]}#{mes[5..6]}N01#{letra}.011"
  end
end
