class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.text :description 
      
      t.boolean :is_deleted, :default => false 
      t.integer :user_id 

      t.timestamps
    end
  end
end
