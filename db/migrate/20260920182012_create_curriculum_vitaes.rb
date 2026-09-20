class CreateCurriculumVitaes < ActiveRecord::Migration[8.1]
  def change
    create_table :curriculum_vitaes do |t|
      t.json :resume
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
