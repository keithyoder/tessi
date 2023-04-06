json.document do
  json.name "Termo #{@contrato.id}"
  json.footer "BOTTOM"
end
json.signers do
  json.child! do
    json.phone "+55#{@contrato.pessoa.telefone1.gsub(/[^0-9]/, '')}"
    json.delivery_method "DELIVERY_METHOD_WHATSAPP"
    json.action "SIGN"
    json.configs do
      json.cpf CPF.new(@contrato.pessoa.cpf).stripped
    end
    json.positions do
      json.child! do
        json.x "8.0"
        json.y "41.5"
        json.z 3
        json.element "SIGNATURE"
      end
      json.child! do
        json.x "15.0"
        json.y "46.0"
        json.z 3
        json.element "NAME"
      end
      json.child! do
        json.x "19.0"
        json.y "51.5"
        json.z 3
        json.element "CPF"
      end
      json.child! do
        json.x "23.0"
        json.y "37.0"
        json.z 3
        json.element "DATE"
      end
    end
  end
end