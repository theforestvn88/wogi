class AddCounterCacheToBrand < ActiveRecord::Migration[7.2]
  def change
    add_column :brands, :custom_fields_count, :integer, default: 0, null: false
  end
end
