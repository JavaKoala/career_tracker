class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :email_address
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
