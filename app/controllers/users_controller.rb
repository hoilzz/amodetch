class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def new
    @user = User.new
    render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
  end

  def timetable
    if params[:search].nil?
      @lectures=Lecture.paginate(:page => params[:page], :per_page => 10 )
      @timetables=current_user.timetables
    
    else
      @lectures=Lecture.search(params[:search]).paginate(:page => params[:page], :per_page => 10 )
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    else
      redirect_to root_url
    end
  end  

  def edit 
  	@user = User.find_by(id: params[:id])
  end

  def update
  	@user=User.find(params[:id])
  	if !params[:user][:nickname].nil?
        @user.update_attribute(:nickname, params[:user][:nickname])
        if @user.valuations.count > 2
  		      redirect_to home_path
        else
            redirect_to :controller => 'static_pages', :action => 'forcingwritting'
        end    
  	else 
    		flash.now[:danger]="닉네임을 빈칸으로 설정할 수 없습니다."
    		render 'edit'
    end
  end


  
private 
    def user_params
      params.require(:user).permit(:nickname, :email, :password,
                                   :password_confirmation)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
    def correct_user 
      @user = User.find(params[:id])
      unless current_user?(@user) 
          flash[:danger]="Invalid access!"
          redirect_to root_path
      end
    end

    def nick_params
    	params.require(:user).permit(:nickname)
    end
end

