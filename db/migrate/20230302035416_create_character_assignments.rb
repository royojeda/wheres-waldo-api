class CreateCharacterAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :character_assignments do |t|
      t.references :game, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end
