class CreateHotels < ActiveRecord::Migration[6.1]
  def change
    create_table :hotels do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.integer :destination_id, null: false, index: true
      t.string :name
      t.decimal :latitude, { precision: 10, scale: 6 }
      t.decimal :longitude, { precision: 10, scale: 6 }
      t.string :address
      t.string :city
      t.string :country
      t.text :description
      t.jsonb :amenities
      t.jsonb :images
      t.string :booking_conditions, array: true, default: []

      t.timestamps
    end
  end
end
