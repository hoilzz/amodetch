class TimetableItemsController < ApplicationController
  before_action :set_timetable_item, only: :destroy
  def create
    @t_item = TimetableItem.new(timetable_item_params)
    @dataTojson = Hash.new
    respond_to do |format|
      if @t_item.save

        schedule = @t_item.schedule

        @dataTojson = schedule.lecture.as_json(only: [:subject, :professor, :isu])

        @dataTojson[:schedule_id] = schedule.id
        @dataTojson[:place] = schedule.place

        sch_details = schedule.schedule_details.select("start_time, end_time, day")
        @dataTojson[:schDetails] = sch_details.as_json(only: [:start_time, :end_time, :day])

        @dataTojson[:timeitem_id] = @t_item.reload.id

        format.json {render json: @dataTojson}
      else
        #format.html{redirect_to @current_timetable}
        format.json {render json: "저장 실패하였습니다.."}
      end

    end

  end

  def destroy
    @t_id = @timetable_item.id
    @timetable_item.destroy

    respond_to do |format|
      format.json {render json: @t_id}
    end
  end

  private
  def timetable_item_params
    params.require(:timetable_item).permit!
  end
  def set_timetable_item
    @timetable_item = TimetableItem.find(params[:id])
  end
end
