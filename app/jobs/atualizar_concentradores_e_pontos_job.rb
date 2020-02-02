class AtualizarConcentradoresEPontosJob < ApplicationJob
  queue_as :default

  def perform
    #Servidor.ativo.each do | servidor |
    #  begin
    #    info = servidor.system_info
    #    servidor.equipamento = info[:'board-name']
    #    servidor.versao = info[:version]
    #    servidor.save     
    #  rescue => exception  
    #  end
    #end
    Ponto.Ubnt.each do | ponto |
      begin
        info = ponto.snmp
        ponto.ssid = info[:ssid]
        ponto.frequencia = info[:frequencia]
        ponto.canal_tamanho = info[:canal_tamanho]
        ponto.save     
      rescue => exception
        
      end
    end
  end
end

#AtualizarConcentradoresEPontosJob.perform()
