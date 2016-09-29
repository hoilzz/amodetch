class Timetable < ActiveRecord::Base
	belongs_to :user
	has_many :schedules, through: :timetable_items
	has_many :timetable_items

	validates :name, presence: true, length: {maximum: 20}
	validates :semester, presence: true

	# scope :countMore1, -> {having('count(user_id) > 1').order('user_id DESC')}
	# scope :countMore2, -> {having('count(user_id) > 2').order('user_id DESC')}

	def reproduce_timetable(original_t, t_name)
		reproduced_t = original_t.dup
		reproduced_t.update_attribute(:name, t_name)
		reproduced_t.save!
		reproduced_t
	end

	def reproduce_enrollment(original_t, reproduced_t)
		original_t.enrollments.each do |e|
			dup_e = e.dup
			dup_e.update_attribute(:timetable_id, reproduced_t.id)
			dup_e.save!
	  	end
	end

	def getStrSemester
		str_semester = semester.to_s
		str_semester = str_semester[0..3]+"-"+str_semester[4]+"학기"
	end


end
