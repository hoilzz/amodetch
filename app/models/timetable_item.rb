class TimetableItem < ActiveRecord::Base
    belongs_to :timetable
    belongs_to :schedule

    validates :timetable_id, presence: true
    validates  :schedule_id, presence: true

    validates :timetable_id, uniqueness: {scope: :schedule_id}
end
