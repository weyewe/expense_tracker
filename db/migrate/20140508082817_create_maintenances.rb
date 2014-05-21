class CreateMaintenances < ActiveRecord::Migration
  def change
    create_table :maintenances do |t|
      
      t.integer :maintenance_contract_id 
      t.integer :maintenance_schedule_id # optional, for scheduled maintenance
      
      t.integer :contract_item_id 
      t.integer :item_id 
      t.integer :customer_id 
      t.integer :user_id  # who is assigned to solve this shite
      
      t.datetime :request_date 
      t.text :complaint 
      t.integer :case, :default => MAINTENANCE_CASE[:scheduled]  # or emergency
      
      
      t.text :diagnosis 
      t.integer :diagnosis_case , :default => DIAGNOSIS_CASE[:all_ok]
      t.datetime :inspection_date
      
      
      t.text :solution 
      t.integer :solution_case , :default => SOLUTION_CASE[:normal]
      t.datetime :finish_date 
      
      t.boolean :is_confirmed , :default => false
      
      t.timestamps
    end
  end
end
