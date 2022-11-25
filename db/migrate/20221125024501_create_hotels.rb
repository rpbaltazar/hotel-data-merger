class CreateHotels < ActiveRecord::Migration[6.1]
  def change
    create_table :hotels do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.integer :destination_id, null: false, index: true
      t.string :name
      t.text :description
      t.decimal :latitude, { precision: 10, scale: 6 }
      t.decimal :longitude, { precision: 10, scale: 6 }
      t.string :address
      t.string :city
      t.string :country
      t.string :postal_code

      t.timestamps
    end
  end
end
