class StaticPagesController < ApplicationController
   before_action :fillnickname, only: [:home]
   before_action :gohome, only: [:daemoon]

  def home
    if params[:search]
      if !params[:major].nil? && !params[:major].include?('모든학과')
        @lectures = Lecture.search_home(params[:search]).where(:major =>params[:major]).order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
      else
       @lectures = Lecture.search_home(params[:search]).order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
      end
    elsif !params[:major].nil? && !params[:major].include?('모든학과')
      @lectures = Lecture.where(:major =>params[:major]).
      order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
    end
  end

  def newsfeed
    if params[:search]
      if !params[:major].nil? && !params[:major].include?('모든학과')
        @lectures = Lecture.search_home(params[:search]).where(:major =>params[:major]).order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
      else
       @lectures = Lecture.search_home(params[:search]).order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
      end
    elsif !params[:major].nil? && !params[:major].include?('모든학과')
      @lectures = Lecture.where(:major =>params[:major]).
      order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
    end
  end

  def goLog
    unless current_user
      flash[:danger]="로그인 후 이용바랍니다."
      redirect_to login_url
    end
  end

  def menual
    @menual_num
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def daemoon
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def first_login
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def support
  end
  

  def forcinglogin
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def home_admin
    if current_user.admin?
      @lectures=Lecture.all.paginate(:page => params[:page], :per_page => 10 )
    else
      redirect_to root_url
    end
  end

  def feedback

  end



  def search
    @lectures = Lecture.where('major = ?', params[:lecture_name])
    render '_home_user'
  end



 private

  def fillnickname
     if logged_in_user? && current_user.nickname.nil?
        flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
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



end
