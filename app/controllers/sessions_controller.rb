class SessionsController < ApplicationController


  def new

  end

  def create
    user = User.find_by(email: params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      log_in user
      current_user

      redirect_to home_path

    else
      flash[:danger] = '아이디 혹은 비밀번호가 잘못 되었습니다.' # Not quite right!
      redirect_to login_path
      end
  end

  def create_by_facebook
    @user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = @user.id
    session[:user_name] = @user.name

    if @user.nickname.nil?
      redirect_to edit_user_path(@user)
      #redirect_to :controller => 'users', :action => 'edit', :id => user.id
    else
      redirect_to home_path
    end


  end

  def destroy
    log_out
    current_user=nil;
    session[:user_id] = nil;
    session[:user_name] = nil;
    redirect_to home_url
  end



  private
    def user_params
      params.require(:user).permit(:provider, :uid, :name, :oauth_token, :oauth_expires_at)
    end
  end
