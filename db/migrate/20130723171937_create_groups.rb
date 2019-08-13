class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      
      t.string :name
      t.string :address
      t.string :time
      t.integer :number_of_members
      

      t.timestamps
    end
  end
end
