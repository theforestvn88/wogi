class AddCanceledAtIndexToCard < ActiveRecord::Migration[7.2]
  def change
    add_index :cards, :canceled_at
  end
end
