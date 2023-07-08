class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :location
      t.string :city
      t.string :state
      t.string :pincode
      t.references :addressable, polymorphic: true

      t.timestamps
    end
  end
end
