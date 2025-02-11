class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :brand, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.decimal :price

      t.timestamps
    end

    add_column :products, :state, :state, default: "active", null: false
  end
end
