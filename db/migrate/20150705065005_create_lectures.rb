class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.string :subject
      t.string :professor
      t.string :major

      t.timestamps null: false
    end
  end
end
