class CreateCats < ActiveRecord::Migration[5.0]
  def change
    create_table :cats do |t| #sql table
      t.date :birth_date, null: false
      t.string :color, null: false
      t.string :name, null: false
      t.string :sex, null: false, limit: 1
      t.text :description

      t.timestamps null: true
    end
      add_index :cats, :name
  end
end
