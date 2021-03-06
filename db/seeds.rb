role = {
  :system => {
    :administrator => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

role = {
  :passwords => {
    :update => true 
  },
  :works => {
    :index => true, 
    :create => true,
    :update => true,
    :destroy => true,
    :work_reports => true ,
    :project_reports => true ,
    :category_reports => true 
  },
  :projects => {
    :search => true 
  },
  :categories => {
    :search => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data_entry',
  :the_role    => role.to_json
)



# if Rails.env.development?

  admin = User.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  admin = User.create_main_user(  :name => "Admin2", :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
  admin = User.create_main_user(  :name => "Admin4", :email => "admin4@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  
  customer_1 = Customer.create_object(
    :name        => "mcnell", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "walawee@gmail.com", 
  )
  
  customer_2 = Customer.create_object(
    :name        => "toll", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "toll@gmail.com", 
  )
  
  customer_3 = Customer.create_object(
    :name        => "penanshin", 
    :address     => " kalibesar no 50 ", 
    :pic         => " WILLY ", 
    :contact     => "082125583534", 
    :email       => "toll@gmail.com", 
  )
  
  customer_array = [customer_1, customer_2, customer_3 ]
  
  type_pc = Type.create_object(
    :name => "PC",
    :description => "Seperangkat komputer: mouse, CPU, Monitor, Speaker (optional)"
  )
  
  type_laptop = Type.create_object(
    :name => "Laptop",
    :description => "Awesome"
  )
  
  type_array = [type_pc, type_laptop]
  
  
  (1..3).each do |x|
    customer_array.each do |customer_object|
      type_array.each do |type_object|
        
        Item.create_object(
          :customer_id              => customer_object.id,
          :type_id                  => type_object.id,
          :description              => "#{customer_object.name} #{type_object.name} #{x} ",
          :manufactured_at          => DateTime.new(2011, 10,10), 
          :warranty_expiry_date     => DateTime.new(2013, 10,10)
        )
      end
    end
  end
  
  puts "Total item: #{Item.all.count}"
  
  
  (1..3).each do |x|
    customer_array.each do |customer_object|
      ContractMaintenance.create_object(
        :customer_id  =>  customer_object.id, 
        :description  =>  "description #{customer_object.id}, count #{x}", 
        :name         =>  "name #{x*customer_object.id}", 
        :started_at   =>  DateTime.new(2011, 10,10), 
        :finished_at  =>  DateTime.new(2014, 10,10)
      )
    end
  end
  
  puts "Total Contract Maintenance #{ContractMaintenance.all.count}"
  
  
  customer_array.each do |customer|
    customer.items.each do |item|
      first_contract_maintenance = customer.contract_maintenances.first 
      ContractItem.create_object(
        :item_id => item.id ,
        :customer_id => customer.id,
        :contract_maintenance_id => first_contract_maintenance.id 
      )
    end
  end
  
  puts "Total ContractItem: #{ContractItem.all.count}"
  
  
  ##################################
  ################################## Expense Tracker
  ##################################
  ##################################
  
  # create contact
  (1..4).each do |x|
    Contact.create_object(
      :name => "Contact name #{x}",
      :description => "Contact description #{x}",
      :user_id => admin.id 
    )
  end
  puts "Total contact: #{Contact.count}"
  
  # create venue
  (1..4).each do |x|
    Venue.create_object(
      :name => "Venue name #{x}",
      :description => "Venue description #{x}",
      :user_id => admin.id 
    )
  end
  puts "Total venue: #{Venue.count}"
  
  # create project 
  (1..4).each do |x|
    Project.create_object(
      :name => "Project name #{x}",
      :description => "Project description #{x}", 
      :user_id => admin.id
    )
  end
  puts "Total project: #{Project.count}"
  
  # create category 
  puts "The admin id : #{admin.id }"
  
  
  last_account = admin.accounts.last 
   
  networking_meal_account = Account.create_object(
  {
    :name                      =>  "Banzai"  , 
    :parent_id                 =>  last_account.id  , 
    :account_case              => ACCOUNT_CASE[:ledger] , 
    :user_id                   =>  admin.id 
  },
    false 
  )
  
  puts "Total account: #{Account.count}"
  
  (1..4).each do |x|
    Expense.create_object(
      :amount => BigDecimal( "50000"),
      :name => "Dinner at Bornga #{x}",
      :description => "bla blablba ",
      :account_id => networking_meal_account.id ,
      :user_id => admin.id ,
      :expensed_at => DateTime.now ,
      :venue_id => Venue.first.id ,
      :project_id => Project.first.id 
    )
  end
  
  puts "Total expense: #{Expense.count}"
  
  