prawn_document(:page_size => 'A5', :margin => [12,12,12,12]) do |pdf|
    #pdf.font_families.update("Arial Unicode MS"=>{:normal =>(Rails.root / 'app' / 'assets' / 'images' / 'arial.ttf')})
    #pdf.font "Arial Unicode MS"
    #pdf.font "/Library/Fonts/Arial Unicode.ttf"
  pdf.font_families.update("OpenSans" => {
      :normal => Rails.root / 'app' / 'assets' / 'fonts' / "OpenSans-Regular.ttf",
      :italic => Rails.root / 'app' / 'assets' / 'fonts' / "OpenSans-Regular.ttf",
      :bold => Rails.root / 'app' / 'assets' / 'fonts' / "OpenSans-Regular.ttf",
      :bold_italic => Rails.root / 'app' / 'assets' / 'fonts' / "OpenSans-Regular.ttf"
  })
  pdf.font "OpenSans"
  esquerda = 13

  pdf.draw_text "Liquidação Manual", :size => 16, :style => :bold, :at => [esquerda,480]
  pdf.draw_text "Assinante: ", :size => 12, :style => :bold, :at => [esquerda,460]
  pdf.draw_text @fatura.pessoa.nome, :size => 12, :style => :bold, :at => [esquerda+100,460]
  pdf.draw_text "Contrato: ", :size => 12, :style => :bold, :at => [esquerda,440]
  pdf.draw_text @fatura.contrato.id, :size => 12, :style => :bold, :at => [esquerda+100,440]
  pdf.draw_text "Parcela: ", :size => 12, :style => :bold, :at => [esquerda,420]
  pdf.draw_text @fatura.parcela, :size => 12, :style => :bold, :at => [esquerda+100,420]
  pdf.draw_text "Valor: ", :size => 12, :style => :bold, :at => [esquerda,400]
  pdf.draw_text number_to_currency(@fatura.valor_liquidacao), :size => 12, :style => :bold, :at => [esquerda+100,400]
  pdf.draw_text "Data: ", :size => 12, :style => :bold, :at => [esquerda,380]
  pdf.draw_text l(@fatura.liquidacao), :size => 12, :style => :bold, :at => [esquerda+100,380]
  pdf.draw_text "Recebido por: ", :size => 12, :style => :bold, :at => [esquerda,360]
  pdf.draw_text current_user.primeiro_nome, :size => 12, :style => :bold, :at => [esquerda+100,360]


  pdf.svg IO.read(Rails.root / 'app' / 'assets' / 'images' / 'logo-cores.svg'), at: [10, 265], width: 100
  pdf.rounded_rectangle [0,270], 390, 270, 10
  pdf.draw_text "RECIBO", :size => 24, :style => :bold, :at => [150,235]
  pdf.rounded_rectangle [260,260], 120, 40, 5
  pdf.text_box number_to_currency(@fatura.valor_liquidacao), :size => 24, :style => :bold, :at => [265,250], :width => 100, :align => :center
  pdf.rounded_rectangle [10,210], 370, 50, 5
  pdf.rounded_rectangle [10,155], 370, 50, 5
  pdf.rounded_rectangle [10,100], 370, 60, 5
  pdf.rounded_rectangle [10,35], 180, 25, 5
  pdf.rounded_rectangle [200,35], 180, 25, 5
  pdf.close_and_stroke
  pdf.draw_text "Prestadora", :size => 8, :style => :bold, :at => [esquerda,202]
  pdf.draw_text 'Tessi - Serviços de Telecomunicação Ltda', :size => 10, :at => [esquerda,190]
  pdf.draw_text 'CNPJ: 07.159.053/0001-07', :size => 10, :at => [esquerda,178]
  pdf.draw_text ('Rua Treze de Maio, 5B - Centro - Pesqueira - PE'), :size => 10, :at => [esquerda,166]
  pdf.draw_text "Assinante", :size => 8, :style => :bold, :at => [esquerda,147]
  pdf.draw_text @fatura.pessoa.nome, :size => 10, :at => [esquerda,136]
  pdf.draw_text 'CPF: '+@fatura.pessoa.cpf, :size => 10, :at => [esquerda,124]
  pdf.draw_text (@fatura.pessoa.endereco + ' - ' + @fatura.pessoa.bairro.nome_cidade_uf), :size => 10, :at => [esquerda,112]
  pdf.text_box "Recebemos de #{@fatura.pessoa.nome} a importância de #{number_to_currency(@fatura.valor_liquidacao)} "+
    "(#{Extenso.moeda((@fatura.valor_liquidacao*100).to_i).downcase}) como quitação da parcela #{@fatura.parcela} " +
    "do contrato #{@fatura.contrato.id}, vencida no dia #{l(@fatura.vencimento)} referente ao serviço de conexão à internet no plano #{@fatura.contrato.plano.nome}" +
    " durante o período de #{l(@fatura.periodo_inicio)} a #{l(@fatura.periodo_fim)}.", :size => 10, :at => [esquerda, 96], :width => 365
  pdf.text_box 'Pesqueira, '+l(@fatura.liquidacao, :default => ''), :size => 12, :style => :bold, :at => [200,28], :width => 180, :align => :center
  pdf.text_box current_user.primeiro_nome, :size => 12, :style => :bold, :at => [esquerda,28], :width => 180, :align => :center
end