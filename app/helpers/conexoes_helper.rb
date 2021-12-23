# frozen_string_literal: true

module ConexoesHelper
  def conexoes_params(params)
    params.permit(
      :tab, :sem_autenticar, :suspensas, :ativas, :conectadas, :desconectadas,
      :sem_contrato
    )
  end
end
