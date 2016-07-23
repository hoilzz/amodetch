class SchedulesController < ApplicationController

  def load
    @schedules = Schedule.getSchedules(params[:timetable_id])

    respond_to do |format|
      format.json {render json: @schedules}
    end
  end

end
