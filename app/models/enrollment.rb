class Enrollment < ActiveRecord::Base
	belongs_to :lecture
	# belongs_to :user
	belongs_to :timetable

	serialize :days, Array
	# validates_uniqueness_of :lecture_id, scope: :timetable_id
end