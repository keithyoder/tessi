class AtualizarConcentradoresEPontosJob < ApplicationJob
  queue_as :default

  def perform
    Servidor.ativo.all.each do | servidor |
      begin
        info = servidor.system_info
        servidor.equipamento = info.board_name
        servidor.versao = info.version
        servidor.save     
      rescue => exception
        
      end
    end
    Ponto.all.each do | ponto |
      begin
        info = ponto.snmp
        ponto.ssid = info.ssid
        ponto.frequencia = info.frequencia
        ponto.save     
      rescue => exception
        
      end
    end
  end
end

AtualizarConcentradoresEPontosJob.perform_now()
