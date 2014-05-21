class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :name
      t.text :description 
      
      t.integer :account_id
      t.boolean :is_project_id_present, :default => false 
      t.integer :project_id 
      
      
      t.boolean :is_venue_id_present, :default => false 
      
      t.integer :venue_id 
      t.datetime :expensed_at 
      
      t.boolean :is_deleted, :default => false 
      
      t.integer :user_id 

      t.timestamps
    end
  end
end
