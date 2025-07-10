class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.string :name, null: false
      t.string :breed, null: false
      t.integer :age, null: false
      t.boolean :vaccinated, null: false, default: true

      t.timestamps
    end
    add_index :pets, :name
  end
end
