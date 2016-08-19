ActiveAdmin.register Schedule do
  filter :lecture_id, as: :numeric

  permit_params :lecture_id, :lecture_time, :semester, :place
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
# form do |f|
#   f.semantic_errors # shows errors on :base
#   f.inputs          # builds an input field for every attribute
#   f.actions         # adds the 'Submit' and 'Cancel' buttons
# end
controller do
    # This code is evaluated within the controller class

    def update
      schedule = Schedule.find(params[:id])
      if schedule.update_attributes(permitted_params[:schedule])
        if params[:schedule][:recent] == "1"
          schedule.update_attribute(:recent, true)
        else
          schedule.update_attribute(:recent, false)
        end
        redirect_to admin_schedule_path(schedule)
      end
      # Instance method

    end

    def create

    end
end

end
