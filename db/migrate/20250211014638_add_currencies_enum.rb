class AddCurrenciesEnum < ActiveRecord::Migration[7.2]
  def up
    create_enum :currencies, [ "USD", "EUR", "JPY", "GBP", "CNY" ]
    add_column :products, :currency, :currencies, default: "USD", null: false
  end

  def down
    remove_column :products, :currency
    execute <<-SQL
      DROP TYPE currencies;
    SQL
  end
end
