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

end
