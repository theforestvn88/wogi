class CreateCustomFields < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_fields do |t|
      t.string :field_name
      t.string :field_type
      t.belongs_to :customable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
