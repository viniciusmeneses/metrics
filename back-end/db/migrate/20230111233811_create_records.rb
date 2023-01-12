class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.datetime :timestamp, null: false
      t.decimal :value, null: false, precision: 10, scale: 2
      t.references :metric, null: false, foreign_key: true

      t.index [:timestamp, :metric_id]

      t.timestamps
    end
  end
end
