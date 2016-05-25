class Timetable < ActiveRecord::Base
	belongs_to :user
	has_many :enrollments, dependent: :destroy
	validates :name, presence: true, length: {maximum: 20}


	scope :countMore1, -> {having('count(user_id) > 1').order('user_id DESC')}
	scope :countMore2, -> {having('count(user_id) > 2').order('user_id DESC')}
	# scope :countAll, -> {where(:user_id => (Timetable.find_by_sql("SELECT user_id FROM timetables WHERE user_id IN (SELECT user_id FROM timetables GROUP BY user_id HAVING COUNT(*) > 1)")))}
	
	# find_by_sql("select * from timetables where user_id IN (SELECT user_id FROM timetables GROUP BY user_id HAVING COUNT(*) > 1)")

	# 7을 반환
	# count_by_sql("SELECT COUNT(*) As count FROM timetables GROUP BY user_id HAVING count > 1 ORDER BY count DESC")

	# array반환하는데, except이 안먹는다고 나옴 
	# find_by_sql("SELECT COUNT(*) As count FROM timetables GROUP BY user_id HAVING count > 1 ORDER BY count DESC") } 
	#   scope :order_by_comments, -> { joins(:comments).order("comments.created_at DESC") }

	# dup을 통해 복제 후,
	# save!까지 하여 timetable_id 생성
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

end