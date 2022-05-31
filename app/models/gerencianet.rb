require 'gerencianet'

class GerencianetClient

  def criar_boleto(fatura)
    cliente = Gerencianet.new(
      {
        client_id: fatura.pagamento_perfil.client_id,
        client_secret: fatura.pagamento_perfil.client_secret,
        sandbox: true
      }
    )

    body = {
      items: [
        {
          name: "Acesso a internet 50M",
          value: fatura.valor,
          amount: 1
        }
      ],
      payment: {
        banking_billet: {
          expire_at: Date.yesterday.strftime,
          customer: {
            name: fatura.pessoa.nome,
            email: fatura.pessoa.email,
            cpf: fatura.pessoa.cpf,
            birth: fatura.pessoa.nascimento.strftime,
            phone_number: fatura.pessoa.telefone
          },
          conditional_discount: {
            type: "currency",
            value: fatura.desconto,
            until_date: fatura.vencimento,
          },
          configurations: {
            fine: 200,
            interest: 33
          },
        }
      }
    }

    cliente.create_charge_onestep(body: body)
  end
end
