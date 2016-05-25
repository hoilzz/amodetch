class ValuationsController < ApplicationController
	
	def create
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
end


