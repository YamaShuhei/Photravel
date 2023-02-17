class ApplicationController < ActionController::Base
  ##デバイス機能実行前にconfigure_permitted_parametersを実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(resource)
    root_path # ログアウト後に遷移するpathを設定
  end 
  
  add_flash_types :success, :info, :warning, :danger
  

  
    protected
  


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :introduction, :profile_image])
  end
    

end
