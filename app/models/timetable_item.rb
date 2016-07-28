# Schema Information

# lecture_id    :  integer ,     limit: 4
# schedule_id   :  integer ,     limit: 4
# timetable_id  :  integer ,     limit: 4
# created_at    :  datetime,     null: false
# updated_at    :  datetime,     null: false

class TimetableItem < ActiveRecord::Base
    belongs_to :timetable
    belongs_to :schedule

    # validator
    validates :timetable_id, :schedule_id, presence: true
    validates :timetable_id, uniqueness: {scope: :schedule_id}

  def makeCellData
    @dataTojson = Hash.new

    schedule = self.schedule

    @dataTojson = schedule.lecture.as_json(only: [:subject, :professor, :isu, :credit])

    @dataTojson[:schedule_id] = schedule.id
    @dataTojson[:place] = schedule.place

    sch_details = schedule.schedule_details.select("start_time, end_time, day")
    @dataTojson[:schDetails] = sch_details.as_json(only: [:start_time, :end_time, :day])

    @dataTojson[:timeitem_id] = self.reload.id

    return @dataTojson
  end

end
