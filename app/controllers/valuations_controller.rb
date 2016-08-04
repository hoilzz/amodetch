class ValuationsController < ApplicationController
	before_action :check_user_valuations, only: [:index]

	def index
		if params[:search]
      if !params[:major].nil? && !params[:major].include?('모든학과')
        @lectures = Lecture.search_home(params[:search]).where(:major =>params[:major]).order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
      else
       @lectures = Lecture.search_home(params[:search]).order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
      end
    elsif !params[:major].nil? && !params[:major].include?('모든학과')
      @lectures = Lecture.where(:major =>params[:major]).
      order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
    end
	end

	# 강의평가를 2번 이상 하지 않은 사용자에게 보여주는 VIEW
	def new
		if params[:search]
			@lectures = Lecture.searchForValuation(params[:search])
			@lectures = @lectures.paginate(:page => params[:page], :per_page => 15)

			@valuation = Valuation.new
		end
	end

	def create
		byebug
	  @lecture= Lecture.find(params[:lecture_id])
		@lecture.lec_valuation(@lecture.valuations.count, params[:total])
		current_user.evaluated_valuation(@lecture, params[:total],params[:content])
		@lecture.save!
  end

  def edit

  end

  def destroy
  	@valuation = Valuation.find_by(id: params[:id])
  	@valuation.destroy
  	redirect_to root_url
  end


		def forcingwritting
			if params[:search]

				if !params[:major].nil? && !params[:major].include?('모든학과')

				@lectures = Lecture.search_home(params[:search]).where(:major =>params[:major]).order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)

				else
				 @lectures = Lecture.search_home(params[:search]).paginate(:page => params[:page], :per_page => 10 )
				end
			elsif !params[:major].nil? && !params[:major].include?('모든학과')
				@lectures = Lecture.where(:major =>params[:major]).
				order("acc_total DESC").paginate(:page => params[:page], :per_page =>10)
			else
			 # @lectures=Lecture.all.order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
				 @lectures=Lecture.search_home('asgreagjergoierjiogjerigjeriogj').order("acc_total DESC").paginate(:page => params[:page], :per_page => 10 )
			end
		end


		private

		def check_user_valuations
			if current_user.valuations.count < 2
				redirect_to new_valuation_path
			end
		end

end
