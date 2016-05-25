class CreatePluralAttrs < ActiveRecord::Migration
  def change
    create_table :plural_attrs do |t|
      t.string :lectureTime
      t.string :place
      t.belongs_to :lecture
      t.timestamps null: false
    end
  end
end
