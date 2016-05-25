class EnrollmentsController < ApplicationController
	def create
		@current_timetable = Timetable.find(params[:timetable_id])

		@request_lecture = @current_timetable.enrollments.build(enrollment_params)
		@request_lecture.save

		@lec = Lecture.find(params[:lecture_id])
		# @place = @lec.place

		respond_to do |format|
			if @request_lecture.save
				format.js
				format.html {redirect_to @current_timetable}
				format.json {render json: @lec}
			else
				format.html{redirect_to @current_timetable}
				format.json {render json: @lec}
			end

		end
	end

	def destroy
		timetable = Timetable.find(params[:timetable_id])

		@lecture = timetable.enrollments.find_by(lecture_id: params[:lecture_id], end_time: params[:end_time])
		@lecture.destroy


		respond_to do |format|
			format.js
			format.html {redirect_to timetable}
			format.json {render json: @lecture}
		end
	end



	private

    def enrollment_params
    	params.permit(:begin_time, :end_time, {:days => []}, :lecture_id, :timetable_id)
    end

    def validate_enrollment

    end








end
