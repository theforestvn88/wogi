class AddBrandState < ActiveRecord::Migration[7.2]
  def up
    create_enum :state, [ "active", "inactive" ]
    add_column :brands, :state, :state, default: "active", null: false
  end

  def down
    remove_column :brands, :state
    execute <<-SQL
      DROP TYPE state;
    SQL
  end
end
