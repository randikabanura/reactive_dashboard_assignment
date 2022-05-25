class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: false, primary_key: %i[name birthdate] do |t|
      t.uuid :uuid, default: "uuid_generate_v4()"
      t.string :name
      t.date :birthdate
      t.integer :gender
      t.text :details
      t.string :phone
      t.text :treatments

      t.timestamps
    end

    add_index :people, %i[name birthdate], unique: true
  end
end
