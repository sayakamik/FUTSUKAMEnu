class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_admin!, if: :admin_url, except: [:sign_in]
  #管理者サインインしていなければ/adminついたページに遷移できないようにする。（sign_in)へ。
  def admin_url
    request.fullpath.include?("/admin")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
