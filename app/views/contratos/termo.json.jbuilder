json.document do
  json.name "Termo de Adesão #{@contrato.id}"
  json.footer "BOTTOM"
end
json.signers do
  json.child! do
    json.email "keith.yoder@gmail.com"
    #json.sms "+5587991638812"
    json.action "SIGN"
    json.configs do
      #json.cpf CPF.new(@contrato.pessoa.cpf).stripped
      json.cpf '00910644497'
    end
    json.positions do
      json.child! do
        json.x "8.0"
        json.y "31.5"
        json.z 3
        json.element "SIGNATURE"
      end
      json.child! do
        json.x "15.0"
        json.y "36.0"
        json.z 3
        json.element "NAME"
      end
      json.child! do
        json.x "19.0"
        json.y "41.5"
        json.z 3
        json.element "CPF"
      end
      json.child! do
        json.x "23.0"
        json.y "27.0"
        json.z 3
        json.element "DATE"
      end
    end
  end
end