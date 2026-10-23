class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products, id: :uuid  do |t|
      t.string :name
      t.string :price
      t.string :color

      t.timestamps
    end
  end
end
