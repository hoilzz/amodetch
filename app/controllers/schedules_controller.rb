class SchedulesController < ApplicationController

  def load
    @schedules = Schedule.getSchedules(params[:timetable_id])

    if !@schedules.nil?
      respond_to do |format|
        format.json {render json: @schedules}
      end
    else
      respond_to do |format|
        format.json {render json: "불러올 강의가 없수다."}
      end
    end
  end


  def new
    @lecture = Lecture.new
    @schedule = Schedule.new
  end

  def create

    		lecture = Lecture.create(lecture_params)
    		schedule = lecture.schedules.create(schedule_params)

    		ScheduleDetail.makeScheduleDetails(schedule.id, schedule.lecture_time)

  end

  private
  def lecture_params
    params.require(:lecture).permit(:subject,
                     :professor, :major, :isu, :credit, :open_department)
  end

  def schedule_params
    params.require(:lecture).permit(:semester, :lecture_time, :place)
  end
end
