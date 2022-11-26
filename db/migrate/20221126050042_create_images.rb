class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string :room_type
      t.references :hotel
      t.string :link
      t.string :description
      t.timestamps
    end
  end
end
