class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :activation_number
      t.string :purchase_pin
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
