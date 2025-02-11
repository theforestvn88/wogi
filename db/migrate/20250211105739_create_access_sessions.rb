class CreateAccessSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :access_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.datetime :expired_at

      t.timestamps
    end

    add_index :access_sessions, [:user_id, :product_id], unique: true
  end
end
