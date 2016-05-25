class Comment < ActiveRecord::Base
	include ActionView::Helpers::DateHelper
	default_scope -> {order(created_at: :desc)}
	validates :content, :length => { :minimum => 1, :maximum => 500 }
	belongs_to :user
	belongs_to :lecture	
	has_many :comment_valuations, dependent: :destroy

	# 사용자가 옳소 누를때 value = +1 || 옳소 취소할 때 -1
	def sum_liked_count(value)
		self.likedcount += value
	end



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

    def timestamp_today?
        if(timestamp_division.include?('방금전')||timestamp_division.include?('분전')||
           timestamp_division.include?('시간전') )
        	return true
        else 
        	return false
      	end  		

    end

    def timestamp_yesterday?
    	if(timestamp_division.include?('어제'))
    		return true
    	else
    		return false
    	end

    end

   
  


end

