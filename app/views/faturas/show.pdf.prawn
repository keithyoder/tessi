prawn_document(:page_size => 'A6', :page_layout => :landscape, :margin => [12,12,12,12]) do |pdf|
    #pdf.font_families.update("Arial Unicode MS"=>{:normal =>(Rails.root / 'app' / 'assets' / 'images' / 'arial.ttf')})
    #pdf.font "Arial Unicode MS"
    #pdf.font "/Library/Fonts/Arial Unicode.ttf"
    pdf.svg IO.read(Rails.root / 'app' / 'assets' / 'images' / 'logo-cores.svg'), at: [10, 265], width: 100
    pdf.rounded_rectangle [0,270], 390, 270, 10
    pdf.draw_text "RECIBO", :size => 24, :style => :bold, :at => [150,235]
    pdf.rounded_rectangle [10,210], 365, 50, 5
    pdf.rounded_rectangle [10,155], 365, 50, 5
    pdf.close_and_stroke
    pdf.draw_text "Prestadora", :size => 8, :style => :bold, :at => [12,202]
    pdf.draw_text "Assinante", :size => 8, :style => :bold, :at => [12,145]
    pdf.draw_text @fatura.pessoa.nome, :size => 10, :at => [12,135]
    pdf.draw_text 'CPF: '+@fatura.pessoa.cpf, :size => 10, :at => [12,125]
    pdf.draw_text (@fatura.pessoa.endereco + ' - ' + @fatura.pessoa.bairro.nome_cidade_uf).force_encoding('iso-8859-1'), :size => 10, :at => [12,115]
  end