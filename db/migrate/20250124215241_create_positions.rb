class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.string :name
      t.text :description
      t.decimal :pay_start
      t.decimal :pay_end
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
