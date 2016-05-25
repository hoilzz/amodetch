class CommentsController < ApplicationController

	def create
		if logged_in_user?
			@comment = current_user.comments.build(lecture_id: params[:lecture_id],
									content: params[:comment][:content])
			@comments = Comment.where("lecture_id = ?", params[:lecture_id]).order('created_at DESC')
			@comment.save

			respond_to do |format|
				format.js
				format.html {redirect_to lecture_path(params[:lecture_id])}
			end
		else
			redirect_to "/auth/facebook", id: "sign_in" 
		end
	end

	def edit
		@comment = Comment.find(params[:id])
		@lecture = Lecture.find_by(id: @comment.lecture_id)
	
		respond_to do |format|
			format.js
			format.html {redirect_to @lecture}
		end
	end

	def update
		@comment = Comment.find(params[:id])
		@lecture = Lecture.find_by(id: params[:lecture_id])
		@comments = Comment.where("lecture_id = ?", @lecture.id).order('created_at DESC')
		if @comment.update_attributes(comment_params)
			respond_to do |format|
				format.js
				format.html {redirect_to @lecture}
			end	
		else

			render @lecture
		end
		
	end

	def destroy
		@comment = Comment.find(params[:id])
		@lecture = Lecture.find_by(id: @comment.lecture_id)
		@comments = Comment.where("lecture_id = ?", @lecture.id).order('created_at DESC')

		@comment.destroy

		respond_to do |format|
			format.js
			format.html {redirect_to @lecture}
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:content)
		end

end
