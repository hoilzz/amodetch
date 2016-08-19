ActiveAdmin.register Lecture do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :subject, :professor, :major, :isu, :credit, :open_department
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
controller do
    # This code is evaluated within the controller class

    def update

      # Instance method

    end

    def create
      lecture = Lecture.new(permitted_params[:lecture])
      if lecture.save
        redirect_to admin_lecture_path(lecture)
      end
    end
end





end
