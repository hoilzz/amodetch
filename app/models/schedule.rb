class Schedule < ActiveRecord::Base
  has_many :timetables, through: :timetable_items
  has_many :timetable_items
  has_many :schedule_details, dependent: :destroy
  belongs_to :lecture

  validates :lecture_time, uniqueness: {scope: [:lecture_id, :semester]}


  def self.getSchedules(lec, semester)
    where("lecture_id = ? AND semester = ? AND recent = true", lec.id, semester)
  end





end
