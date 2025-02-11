class AddCardStateToCards < ActiveRecord::Migration[7.2]
  def up
    create_enum :card_state, ["issued",  "active", "canceled" ]
    add_column :cards, :state, :card_state, default: "issued", null: false
  end

  def down
    remove_column :cards, :state
    execute <<-SQL
      DROP TYPE card_state;
    SQL
  end
end
