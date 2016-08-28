class SchedulesController < ApplicationController

  before_action :admin_user, only: [:destroy, :edit, :create, :update, :new]

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

    @schedule = Schedule.new
    @lecture = Lecture.find(params[:lecture_id])

  end

  def create
    schedules = Schedule.where("semester = ? AND lecture_id = ?", params[:schedule][:semester], params[:schedule][:lecture_id]).update_all(recent: false)
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      # schedule_detail도 생성
      ScheduleDetail.makeScheduleDetails(@schedule.id, @schedule.lecture_time)
      redirect_to :back
    else
      render 'new'
    end

  end


  def edit
  end

  # 스케줄 수정할 때 동시에, 스케줄 디테일도 수정해야한다
  def update

  end

  private
  def lecture_params
    params.require(:lecture).permit(:subject,
                     :professor, :major, :isu, :credit, :open_department)
  end

  def schedule_params
    params.require(:schedule).permit(:semester, :lecture_time, :place, :lecture_id, :recent)
  end

  def admin_user
		redirect_to(root_url) unless current_user.admin?
	end
end
