class ValuationsController < ApplicationController
	before_action :check_user_valuations, only: [:index]

	def index

	end

	# 강의평가를 2번 이상 하지 않은 사용자에게 보여주는 VIEW
	def new
		@is_search = false

		if params[:search]
			@lectures = Lecture.searchForValuation(params[:search])
			@lectures = @lectures.paginate(:page => params[:page], :per_page => 15)

			@valuation = Valuation.new
			@is_search = true
		end
	end

	def create
		# valuation 생성(현재 유저의 평가임, 이 평가는 이 렉처에 속함)
		# lecture 평균별점 업데이
		@valuation = current_user.valuations.build(valuation_params)
		@valuation.lecture.update_avr_rating(@valuation.rating)

		if @valuation.save
			respond_to do |format|
				format.json { render json: @valuation.lecture, status: :created}
			end
		else
			respond_to do |format|
				format.json { render json: @valuation.errors, status: :unprocessable_entity}
			end
		end
  end

  def edit

  end

  def destroy
  	@valuation = Valuation.find_by(id: params[:id])
  	@valuation.destroy
  	redirect_to root_url
  end


		private

		def check_user_valuations
			if current_user.valuations.count < 2
				redirect_to new_valuation_path
			end
		end

		def valuation_params
			params.require(:valuation).permit(:content, :rating, :lecture_id)
		end

end
