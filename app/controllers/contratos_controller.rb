class ContratosController < ApplicationController
  include ActionView::Helpers::NumberHelper
  load_and_authorize_resource
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]

  # GET /contratos
  # GET /contratos.json
  def index
    @q = Contrato.ransack(params[:q])
    @q.sorts = "pessoa_nome"
    @contratos = @q.result.page params[:page]
  end

  # GET /contratos/1
  # GET /contratos/1.json
  # GET /contratos/1.pdf
  def show
    @contrato = Contrato.find(params[:id])
    if request.format != :pdf
      @faturas = @contrato.faturas.order(parcela: :desc).page params[:page]
    else
      puts "create pdf"
      pdf = FillablePDF.new('public/termo.pdf')
      puts "set fields"
      pdf.set_fields(
        assinante_nome: @contrato.pessoa.nome,
        assinante_cpf_cnpj: @contrato.pessoa.cpf,
        assinante_rg_ie: @contrato.pessoa.rg,
        contrato_numero: @contrato.id,
        assinante_nascimento: I18n.localize(@contrato.pessoa.nascimento),
        assinante_telefone1: helpers.num_to_phone(@contrato.pessoa.telefone1),
        assinante_telefone2: helpers.num_to_phone(@contrato.pessoa.telefone2),
        assinante_logradouro: @contrato.pessoa.logradouro.nome,
        assinante_endereco_numero: @contrato.pessoa.numero,
        assinante_endereco_complemento: @contrato.pessoa.complemento,
        assinante_bairro: @contrato.pessoa.logradouro.bairro.nome,
        assinante_cidade: @contrato.pessoa.logradouro.bairro.cidade.nome,
        assinante_estado: @contrato.pessoa.logradouro.bairro.cidade.estado.sigla,
        assinante_cep: @contrato.pessoa.logradouro.cep,
        plano: @contrato.plano.nome,
        upload: @contrato.plano.upload,
        download: @contrato.plano.download,
        instalacao: number_to_currency(@contrato.valor_instalacao),
        parcelas_instalacao: '-x-',
        vencimento_parcelas: '-x-',
        valor_parcela: '-x-',
        mensalidade: number_to_currency(@contrato.plano.mensalidade),
        dia_vencimento: @contrato.dia_vencimento,
        forma_pagamento: 'Boleto',
        contrato_data: I18n.localize(@contrato.adesao, format: :long)
      )
      puts "create temp file"
      file = Tempfile.new('contrato')
      puts "save pdf"
      pdf.save_as(file, flatten: true)
      puts "close"
      pdf.close 
    end
    respond_to do |format|
      format.html { render :show }
      format.pdf { send_file(file, file_name: "Termo Adesão "+@contrato.pessoa.nome, type: :pdf, disposition: :inline) }
    end
  end

  # GET /contratos/new
  def new
    @contrato = Contrato.new
  end

  # GET /contratos/1/edit
  def edit
  end

  # POST /contratos
  # POST /contratos.json
  def create
    @contrato = Contrato.new(contrato_params)

    respond_to do |format|
      if @contrato.save
        format.html { redirect_to @contrato, notice: 'Contrato was successfully created.' }
        format.json { render :show, status: :created, location: @contrato }
      else
        format.html { render :new }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratos/1
  # PATCH/PUT /contratos/1.json
  def update
    respond_to do |format|
      if @contrato.update(contrato_params)
        format.html { redirect_to @contrato, notice: 'Contrato was successfully updated.' }
        format.json { render :show, status: :ok, location: @contrato }
      else
        format.html { render :edit }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratos/1
  # DELETE /contratos/1.json
  def destroy
    @contrato.destroy
    respond_to do |format|
      format.html { redirect_to contratos_url, notice: 'Contrato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contrato
      @contrato = Contrato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contrato_params
      params.require(:contrato).permit(:pessoa_id, :plano_id, :status, :dia_vencimento, :adesao, :valor_instalacao, :numero_conexoes, :cancelamento, :emite_nf, :primeiro_vencimento, :prazo_meses)
    end
end
