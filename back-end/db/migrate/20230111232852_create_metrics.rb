class CreateMetrics < ActiveRecord::Migration[7.0]
  def change
    create_table :metrics do |t|
      t.string :name, null: false, limit: 30

      t.timestamps
    end
  end
end
