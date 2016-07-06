class Schedule < ActiveRecord::Base
  has_many :timetables, through: :timetable_items
  has_many :timetable_items
  has_many :schedule_details, dependent: :destroy
  belongs_to :lecture

  validates :lecturetime, uniqueness: {scope: :semester}

end
