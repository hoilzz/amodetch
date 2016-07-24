class TimetableItemsController < ApplicationController
  before_action :set_timetable_item, only: :destroy
  def create
    @t_item = TimetableItem.new(timetable_item_params)

    if @t_item.save
      # @dataTojson = { Lecture : {subject, professor, isu},
      #                  Schedule : {id, place}}
      #                  ScheduleDetails : {start_time, end_time, day}...}
      respond_to do |format|
        @dataTojson = @t_item.makeCellData
        format.json {render json: @dataTojson}
      end

      #format.html{redirect_to @current_timetable}
      #TODO 클라에서 중복 검사 실패시, 중복된 강의를 create 하려 할 것이다.
      # 이 때, validate 때문에 실패하는데 이에 대한 장치를 json or anything 필요..
    else
        respond_to do |format|
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
