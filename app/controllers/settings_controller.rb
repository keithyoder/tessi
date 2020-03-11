class SettingsController < ApplicationController
  #load_and_authorize_resource
  skip_authorization_check
  before_action :get_setting, only: [:edit, :update]

  def create
    setting_params.keys.each do |key|
      Setting.send("#{key}=", setting_params[key].strip) unless setting_params[key].nil?
    end
    redirect_to settings_path, notice: "Configurações atualizadas."
  end

  private
    def setting_params
      params.require(:setting).permit(:razao_social, :cnpj, :juros, :multa)
    end
end
