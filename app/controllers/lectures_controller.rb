class LecturesController < ApplicationController

	before_action :admin_user, only: [:destroy, :edit, :create, :update, :new, :import]
	before_action :fillnickname, only: [:show]
	before_action :correct_user, only: [:timetable]
	before_action :godaemoon, only:[:show]
	before_action :goforcingwritting, only:[:show]

	require 'roo'

	def show
		@lecture = Lecture.find_by(id: params[:id])
		@valuations = Valuation.where("lecture_id = ?", @lecture.id).order("created_at DESC")
	end

	def edit
		@lecture = Lecture.find_by(id: params[:id])
	end

	def new
		@lecture = Lecture.new
	end

	def create
		Lecture.create(subject: params[:lecture][:subject],
					   professor: params[:lecture][:professor], 
					   major: params[:lecture][:major],
					   lecturetime: params[:lecture][:lecturetime])
		redirect_to root_url
	end

	def update
		@lecture = Lecture.find_by(id: params[:id])
		if @lecture.update_attributes(lecture_params)
			redirect_to home_admin_url
		else
			render 'edit'
		end
	end

	def destroy
		@lecture = Lecture.find_by(id: params[:id])
		@lecture.destroy
		redirect_to root_url
	end 

	def import
		Lecture.import(params[:file])
		redirect_to root_url, notice: "decorations imported."
  	end

	def writtingform
		@lecture = Lecture.find_by(id: params[:id])
	end



	private

		def forcingwritting
			if logged_in_user? && current_user.valuations.count < 4
				redirect_to :controller => 'static_pages', :action => 'forcingwritting'
			end
		end


		def lecture_params
			params.require(:lecture).permit(:subject,
											 :professor, :major, :lecturetime)
		end


		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end


		def fillnickname 
			if logged_in_user? && current_user.nickname.nil?
				flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
				redirect_to edit_user_url(current_user)
			end
		end


		def correct_user 
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

	    def godaemoon
		    unless user_login?
		      redirect_to root_path
		    end
	    end

	    def goforcingwritting
      	if current_user.valuations.count<2
        	redirect_to forcingwritting_path
      end 
  end

end
