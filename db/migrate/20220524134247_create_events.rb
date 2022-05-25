class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: false, primary_key: %i[name birthdate] do |t|
      t.string :name
      t.date :birthdate
      t.string :title
      t.text :description
      t.integer :event_type

      t.timestamps
    end

    add_index :events, %i[name birthdate], unique: true
  end
end
