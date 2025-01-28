class CompanyUniqueIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :companies, :name, unique: true
  end
end
