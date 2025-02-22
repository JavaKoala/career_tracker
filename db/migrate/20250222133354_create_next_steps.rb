class CreateNextSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :next_steps do |t|
      t.text :description
      t.datetime :due
      t.references :job_application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
