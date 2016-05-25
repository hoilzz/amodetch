class CommentValuationsController < ApplicationController
	def create
		# 현재유저가 이 댓글에 대해 평가한적 있니?
		# 현재유저.
		unless current_user.comment_valuations.find_by(comment_id: params[:comment_id])
			@comment = Comment.find(params[:comment_id])
			@comment.sum_liked_count(1)
			byebug
			@comment_valuation = current_user.comment_valuations.build(lecture_id: params[:lecture_id],	comment_id: params[:comment_id])
			# true로 전환시 해당 comment에 대해 좋아요 누름
			@comment_valuation.set_comment_valuation(true)
			
			@comment.save!
			@comment_valuation.save!
		end

		@lecture = Lecture.find(params[:lecture_id])

		respond_to do |format|
			format.html {redirect_to @lecture}
			format.js
		end

	end

	def destroy
		@comment_valuation = current_user.comment_valuations.find(params[:id])
		@comment_valuation.destroy

		@lecture = Lecture.find(params[:lecture_id])
		@comment = Comment.find(params[:comment_id])
		@comment.sum_liked_count(-1)
		@comment.save!
		respond_to do |format|
			format.html {redirect_to @lecture}
			format.js
		end

		# a = user.comment_valuations.find_by(parmas[:id])
	end


























end
