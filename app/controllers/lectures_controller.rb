class LecturesController < ApplicationController

	before_action :admin_user, only: [:destroy, :edit, :create, :update, :new, :import]
	before_action :fillnickname, only: [:show]

	require 'roo'

	def show
		@lecture = Lecture.find_by(id: params[:id])
		@valuations = Valuation.where("lecture_id = ?", @lecture.id).order("created_at DESC")
		@valuation = Valuation.new
	end

	def edit
		@lecture = Lecture.find_by(id: params[:id])
	end

	def new
		@lecture = Lecture.new
	end

	def create
		# lecture 생성
		# lecture.schedule 생성
		# schedule.schedule_detail생성

		redirect_to root_url
	end

	def update
		@lecture = Lecture.find_by(id: params[:id])
		if @lecture.update_attributes(lecture_params)
			redirect_to home_admin_url
		else
			render 'edit'
		end
	end

	def destroy
		@lecture = Lecture.find_by(id: params[:id])
		@lecture.destroy
		redirect_to root_url
	end

	def import
		Lecture.import(params[:file])
		redirect_to root_url, notice: "decorations imported."
	end


	def search
		 @dataTojson = Lecture.getLecturesBeSearched(params[:searchWord], params[:semester], params[:pageSelected])
		 respond_to do |format|
		 	format.json {render json:	@dataTojson}
		 end
	end


	private

	

		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end


		def fillnickname
			if logged_in_user? && current_user.nickname.nil?
				flash[:danger]= "닉네임을 설정하여 주세요. 익명성 보장을 위함입니다."
				redirect_to edit_user_url(current_user)
			end
		end




end
