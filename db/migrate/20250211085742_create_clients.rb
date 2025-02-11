class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.float :payout_rate

      t.timestamps
    end
  end
end
