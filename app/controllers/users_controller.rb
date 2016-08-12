class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
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
  		  redirect_to home_path
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
