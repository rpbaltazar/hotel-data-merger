class AddLastGeneratedAtToHotel < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :last_generated_at, :datetime
  end
end
