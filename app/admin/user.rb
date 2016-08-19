ActiveAdmin.register User do
	permit_params :email, :admin, :uid, :name, :provider
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
# controller do
# 	def scoped_collection
# 		super.includes
# end

# controller do
#     # This code is evaluated within the controller class
#
#     def update
# 			user = User.find(params[:id])
# 			user.update_attribute(:admin, true)
#       # Instance method
# 			redirect_to admin_user_path(user)
#     end
#   end

show do
	h3 user.timetables.count
	div do
		tabs do
			tab 'timetable' do
				panel "Table of Contents" do
					table_for user.timetables do
						column :name
					end

				end
			end
		end
	end
	active_admin_comments
end

index do
	selectable_column
	column :name
	column :nickname

	column :updated_at
	actions
end

end
