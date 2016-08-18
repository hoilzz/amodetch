class StaticPagesController < ApplicationController
   before_action :fillnickname, only: [:home]
   before_action :gohome, only: [:daemoon]
   skip_before_action :require_login, only: [:home]
   before_action :admin_user, only: [:home_admin]


  def home
  end

  def home_admin
    
  end


 private

  def fillnickname
     if logged_in_user? && current_user.nickname.nil?
        redirect_to edit_user_url(current_user)
     end
  end


  def user_login?
    if session[:user_id].nil? && session[:user_name].nil?
        false
    else
        true
    end
  end

  def gohome
    if user_login?
      redirect_to home_path
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end



end
