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
					   major: params[:lecture][:major])
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

	def search
		@lecArr = []
		@dataTojson = Hash.new	# Hash로 선언 후, 전송 전에 json으로 변경

		@lectures = Lecture.searchOnTimetable(params[:searchWord], params[:semester])

		@dataTojson[:totalSearched] =  @lectures.joins(:schedules).where("schedules.semester" => params[:semester]).select("schedules.*").size
							 #	= Lecture.extractSchedules(@lectures, params[:semester])

		offsetByPage = (params[:pageSelected].to_i - 1) * 8

		@schedulesPrinted = @lectures.joins(:schedules).where("schedules.semester" => params[:semester]).select("schedules.*").offset(offsetByPage).limit(8)

		@schedulesPrinted.each do |sch|
			lectureObj = Hash.new

			lectureObj = Lecture.find(sch.lecture_id).as_json(only: [:subject, :professor, :open_department])

			schduleObj = sch.as_json(only: [:lecture_id, :lecture_time])

			schDetailObjs = ScheduleDetail.where(schedule_id: sch.id).select("start_time, end_time, day")
			if schDetailObjs.size == 0
				# 싸강
			elsif schDetailObjs.size == 1
				#temp = schDetailObjs
				#schDetailObjs = Array.new
				#schDetailObjs.push(temp)
			end

			lectureObj = lectureObj.merge(schduleObj)

			lectureObj[:schDetails] = schDetailObjs.as_json(only: [:start_time, :end_time, :day])

			@lecArr.push(lectureObj)
		end


		@dataTojson[:pageSelected] = params[:pageSelected]
		@dataTojson[:pageTotal] = (@dataTojson[:totalSearched] / 8) + ((@dataTojson[:totalSearched].to_i % 8 + 7) / 8)

		#@lecArr.push(@dataTojson)
		@dataTojson[:lectures] = @lecArr
		 respond_to do |format|
		 	format.json {render json:	@dataTojson}
		 end
	end


	private




		def forcingwritting
			if logged_in_user? && current_user.valuations.count < 4
				redirect_to :controller => 'static_pages', :action => 'forcingwritting'
			end
		end


		def lecture_params
			params.require(:lecture).permit(:subject,
											 :professor, :major, :lecture_time)
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
