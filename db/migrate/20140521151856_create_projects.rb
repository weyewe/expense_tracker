class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name 
      t.text :description 
      
      t.boolean :is_deleted , :default => false 
      
      t.integer :contact_id 
      t.integer :user_id 

      t.timestamps
    end
  end
end
