class Valuation < ActiveRecord::Base
	belongs_to :user
	belongs_to :lecture

  	scope :join_major, -> { joins(:lecture)}

	def timestamp_division
		difference = Time.zone.now - created_at
		# 0 ~ 59초전
		if difference < 60
			"방금전"
		# 1분 ~ 60분전
		elsif difference > 60 && difference < 3600
			(difference/60).to_i.to_s + "분전"
		# 1시간 ~ 24시간
		elsif difference > 3600 && difference < 86400
			(difference/3600).to_i.to_s + "시간전"
		# 하루 전
		elsif difference > 86400 && difference < 172800
			"어제"
		#과거 
		else
			created_at.strftime("%m/%d %H:%M")
		end
	end

end
