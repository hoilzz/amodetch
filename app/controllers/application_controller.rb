class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login



  include SessionsHelper

  helper_method :current_user

  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def require_login
    unless is_logged_in?
      flash[:error] = "로그인 후 이용가능합니다!"
      redirect_to login_path # halts request cycle
    end
  end

end
