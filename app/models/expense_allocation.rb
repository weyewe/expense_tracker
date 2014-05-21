class ExpenseAllocation < ActiveRecord::Base
  belongs_to :contact
  belongs_to :expense 
end
