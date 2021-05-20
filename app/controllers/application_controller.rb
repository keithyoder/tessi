class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  check_authorization unless: :nao_autenticar?
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def nao_autenticar?
    respond_to?(:devise_controller?) or
      respond_to?(:sac_controller?)
  end
end
