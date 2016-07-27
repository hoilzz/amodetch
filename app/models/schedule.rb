  # SCHEMA INFO
  # string   "lecture_time"
  # string   "semester"
  # datetime "created_at"
  # datetime "updated_at"
  # integer  "lecture_id"
  # boolean  "recent"
  # string   "place"
class Schedule < ActiveRecord::Base
  has_many :timetables, through: :timetable_items
  has_many :timetable_items
  has_many :schedule_details, dependent: :destroy
  belongs_to :lecture

  # Scope의 칼럼은 OR 개념
  # 시간 강의 학기
  # 위 3가지 칼럼 중 기준이 되는 레코드와 1개라도 다르면 valid object
  # 주관학과를 schedule에 또 추가한 이유는 호관대에서 강의(강의명 교수명), 학기, 장소, 강의시간이 같은데 주관학과만 다른경우가 많음
  # 그래서 매번 validation에서 reject 당하기 때문에 추가해서 validation scope에 추가
  validates :lecture_time, uniqueness: {scope: [:lecture_id, :semester, :place]}

  def self.getSchedules(timetable_id)
		# 현재 타임테이블에 속한 schedule, scheduleDetail 가져오기
		#  data = { Lecture : {subject, professor, isu},
    #          Schedule : {id, place}}
    #   ScheduleDetails : {start_time, end_time, day}...}
		@dataTojson = Hash.new
		@lecturesArr = Array.new

		@time_items = TimetableItem.where("timetable_id = ?", timetable_id)# current_timetable.timetable_items
    if !@time_items.nil?
  		@time_items.each do |t_item|

  			lecObj = Hash.new
  			sch = t_item.schedule

  			lecObj = sch.lecture.as_json(only: [:subject, :professor, :isu])
        lecObj[:timeitem_id] = t_item.id
  			lecObj[:schDetails] = sch.schedule_details.as_json(only: [:start_time, :end_time, :day])
  			lecObj[:place] = t_item.schedule.place
  			lecObj[:schedule_id] = sch.id

  			@lecturesArr.push(lecObj)
  		end
  		@dataTojson[:lectures] = @lecturesArr

  		return @dataTojson

    else

    end

	end



end
