class ApplicationController < ActionController::Base
  ##デバイス機能実行前にconfigure_permitted_parametersを実行
  before_action :configure_permitted_parameters, if: :devise_controller?
    
    
    protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
    
end
