class CreateExpenseAllocations < ActiveRecord::Migration
  def change
    create_table :expense_allocations do |t|
      
      t.integer :contact_id 
      t.integer :expense_id 

      t.timestamps
    end
  end
end
