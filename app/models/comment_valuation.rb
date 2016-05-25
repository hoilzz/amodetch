class CommentValuation < ActiveRecord::Base
	belongs_to :user
	belongs_to :lecture
	belongs_to :comment

	def set_comment_valuation(bool)
		self.like = bool
	end
end
