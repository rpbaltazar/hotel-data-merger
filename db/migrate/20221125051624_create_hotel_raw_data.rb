class CreateHotelRawData < ActiveRecord::Migration[6.1]
  def change
    create_table :hotel_raw_data do |t|
      t.string :source
      t.string :identifier, index: true
      t.integer :destination_id
      t.string :name
      t.decimal :latitude, { precision: 10, scale: 6 }
      t.decimal :longitude, { precision: 10, scale: 6 }
      t.string :address
      t.string :postal_code
      t.string :city
      t.string :country
      t.string :description
      t.jsonb :images
      t.jsonb :amenities
      t.string :booking_conditions, array: true

      t.timestamps
    end
  end
end
