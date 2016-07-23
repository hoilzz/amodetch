class TimetablesController < ApplicationController
	before_action :goLog, only: [:new, :show]

	def show
    @current_timetable = current_user.timetables.find(params[:id])
		@timetables = current_user.timetables

	end

	def goLog
		unless current_user
			flash[:danger]="로그인 후 이용 바랍니다."
			redirect_to login_path
		end
	end

	def new
		@timetable = Timetable.new
	end

	def edit
		@timetable = Timetable.find_by(id: params[:id])
	end

	def update
		@timetable = Timetable.find(params[:id])
		if !params[:timetable][:name].nil?
			@timetable.update_attribute(:name, params[:timetable][:name])
			redirect_to timetable_path(@timetable)
		else
			render 'edit'
		end
	end

	def create

		@timetable = current_user.timetables.build(timetable_params)
		if @timetable.save
			redirect_to timetable_path(@timetable)
		else
			render 'new'
		end
	end

	def destroy
		timetable = current_user.timetables.find(params[:id])
		timetable.destroy

		redirect_to home_path
	end


	def copy
		@existed_timetable = Timetable.find(params[:id])
	end

	def paste
		@existed_t = Timetable.find(params[:timetable][:id])

		#복제시 이름 같이 업데이트, 그래서 이름값 인자로 같이 보냄
		@reproduced_t = reproduce_timetable(@existed_t, params[:timetable][:name])
		reproduce_enrollment(@existed_t, @reproduced_t)

		redirect_to timetable_path(@reproduced_t)
	end

	def detailsearch
		render(:layout => "layouts/noheader") #헤더파일 포함 안함 !
	end


	private

	def timetable_params
		params.require(:timetable).permit(:name,:semester)
	end


end
