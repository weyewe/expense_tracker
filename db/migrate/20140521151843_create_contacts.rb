class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.text :description 
      
      
      t.integer :user_id 
      
      t.boolean :is_deleted, :default => false 

      t.timestamps
    end
  end
end
