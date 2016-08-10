class ChangeAccTotalFromLectures < ActiveRecord::Migration
  def change
    rename_column :lectures, :acc_total, :avr_rating
  end
end
