class ApplicationController < ActionController::Base
  ##デバイス機能実行前にconfigure_permitted_parametersを実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリンク先指定（管理者/ユーザー別)
  def after_sign_in_path_for(resource_or_scope)
    # 管理者がログインした場合は管理者トップページへ
    if resource.is_a?(Admin)
      admin_root_path
    else
    # ユーザーがログインした場合はユーザー用トップページへ
      root_path
    end
  end
  
  # ログアウト後のリンク先指定（管理者/ユーザー別）
  def after_sign_out_path_for(resource_or_scope)
    # 管理者がログアウトした場合は管理者用ログインページへ
    if resource_or_scope == :admin
      new_admin_session_path
    else
    # ユーザーがログアウトした場合はユーザー用トップページへ
      root_path
    end
  end  

  
  add_flash_types :success, :info, :warning, :danger
  

  
    protected
  


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :introduction, :profile_image])
  end
    

end
