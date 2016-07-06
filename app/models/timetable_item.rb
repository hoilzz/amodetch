class TimetableItem < ActiveRecord::Base
    belongs_to :timetable
    belongs_to :schedule
end
