class Schedule < ActiveRecord::Base
  has_many :timetables, through: :timetable_items
  has_many :timetable_items
  has_many :schedule_details, dependent: :destroy
  belongs_to :lecture

  validates :lecture_time, uniqueness: {scope: [:lecture_id, :semester]}

  def self.getSchedules(timetable_id)
		# 현재 타임테이블에 속한 schedule, scheduleDetail 가져오기
		#  data = { Lecture : {subject, professor, isu},
    #          Schedule : {id, place}}
    #   ScheduleDetails : {start_time, end_time, day}...}
		@dataTojson = Hash.new
		@lecturesArr = Array.new

		@time_items = TimetableItem.where("timetable_id = ?", timetable_id)# current_timetable.timetable_items

		@time_items.each do |t_item|

			lecObj = Hash.new

			sch = t_item.schedule

			lecObj = sch.lecture.as_json(only: [:subject, :professor, :isu])
			lecObj[:schDetails] = sch.schedule_details.as_json(only: [:start_time, :end_time, :day])
			lecObj[:place] = t_item.schedule.place
			lecObj[:schedule_id] = sch.id

			@lecturesArr.push(lecObj)
		end
		@dataTojson[:lectures] = @lecturesArr

		return @dataTojson
	end



end
