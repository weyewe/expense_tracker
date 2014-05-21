class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|

      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth # this is optional.
       t.boolean :is_base_account, :default => false 
      
      t.integer :account_case , :default => ACCOUNT_CASE[:ledger]
      t.integer :classification


      t.timestamps
    end
  end
end
