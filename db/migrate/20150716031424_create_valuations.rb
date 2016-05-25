class CreateValuations < ActiveRecord::Migration
  def change
    create_table :valuations do |t|

      t.integer :valuated

      t.references :user, foreign_key: true
      t.references :lecture, foreign_key: true

      t.timestamps null: false
    end
  end
end
