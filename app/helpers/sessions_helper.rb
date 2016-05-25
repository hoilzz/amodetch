module SessionsHelper

# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
	end

	def is_logged_in?
    	!session[:user_id].nil?
  	end
  	
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def logged_in_user?
		!session[:user_id].nil?
	end

	def current_user?(user)
		user == current_user
	end

	def log_out
	    session.delete(:user_id)
	    @current_user = nil
  	end

end
