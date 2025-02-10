class AddBrandState < ActiveRecord::Migration[7.2]
  def up
    create_enum :brand_state, [ "active", "inactive" ]
    add_column :brands, :state, :brand_state, default: "active", null: false
  end

  def down
    remove_column :brands, :state
    execute <<-SQL
      DROP TYPE brand_state;
    SQL
  end
end
