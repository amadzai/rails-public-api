class CreateTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :tokens do |t|
      t.string  :coingecko_id, null: false
      t.string  :symbol, null: false
      t.string  :name, null: false
      t.string  :image
      t.decimal :current_price, precision: 20, scale: 8, null: false, default: 0
      t.decimal :market_cap, precision: 30, scale: 2, null: false, default: 0
      t.integer :market_cap_rank
      t.decimal :total_volume, precision: 30, scale: 2
      t.decimal :price_change_percentage_24h, precision: 10, scale: 4
      t.datetime :last_ingested_at, null: false

      t.timestamps
    end

    add_index :tokens, :coingecko_id, unique: true
    add_index :tokens, :market_cap
    add_index :tokens, :symbol
  end
end
