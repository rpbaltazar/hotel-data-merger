class CreateAmenities < ActiveRecord::Migration[6.1]
  def change
    create_table :amenities do |t|
      t.string :room_type
      t.references :hotel
      t.string :description

      t.timestamps
    end
  end
end
