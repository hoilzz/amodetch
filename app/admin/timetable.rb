ActiveAdmin.register Timetable do
scope :countMore1
scope :countMore2
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
# show do
# 	attributes_Table do
# 		row :name
# 	end
# end #h3 t.user.nickname
	index do
		selectable_column
		column :nickname, sortable: :created_at do |t|
			if t.user
				h3 t.user.nickname
			end
		end
		column :id
		column :name
		column :created_at
		column :updated_at
		column :enrollment_count, sortable: :created_at do |t|
			if t.enrollments
				h5 t.enrollments.count
			end
		end
		# panel "Table of enrollments" do
		# 	table_for timetable.enrollments do
		# 		column "subject_count" do |c|

		# 		end
		# 	end
		# end
		actions
	end

end
