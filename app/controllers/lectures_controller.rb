class LecturesController < ApplicationController

	before_action :admin_user, only: [:destroy, :edit, :create, :update, :new, :import, :index]
	before_action :fillnickname, only: [:show]
	before_action :check_user_valuations, only: [:show]

	require 'roo'

	def index
		@is_search = false

		if params[:search]
			@lectures = Lecture.searchForValuation(params[:search])
			@lectures = @lectures.paginate(:page => params[:page], :per_page => 15)

			@is_search = true
		end
	end

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
		@lecture = Lecture.new(lecture_params)
		if @lecture.save
			redirect_to lectures_path
		else
			render 'new'
		end

	end

	def update
		@lecture = Lecture.find_by(id: params[:id])
		if @lecture.update_attributes(lecture_params)
			redirect_to :back
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

	def lecture_params
		params.require(:lecture).permit(:subject, :professor, :major,
																 :isu, :credit, :open_department)
	end

	def check_user_valuations
		if current_user.valuations.count < 2
			redirect_to new_valuation_path
		end
	end

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
