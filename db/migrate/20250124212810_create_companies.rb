class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :friendly_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :county
      t.string :zip
      t.string :country
      t.text :description

      t.timestamps
    end
  end
end
