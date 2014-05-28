class Account < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :user 
  has_many :expenses 
  
  validates_presence_of :name, :account_case , :user_id 
  
  
  
  validate :parent_id_present_for_non_base_account
  validate :valid_account_case
  
  validate :valid_user_id
  
  def valid_user_id
    assigned_user =  User.find_by_id user_id
    
    if assigned_user.nil?
      self.errors.add(:user_id , "Harus ada dan valid")
      return self
    end
  end
  
  
  
  def unique_non_deleted_name_on_current_user
    return if user_id.nil? or name.nil? 
    
    current_user_id = self.user_id
    current_name = self.name 
    
    total_active_object_with_same_name  = Contact.where(
                        :user_id => current_user_id, 
                        :name => current_name).count
                        
    if self.persisted?
      if total_active_object_with_same_name > 1 
        self.errors.add(:name, "Sudah ada yang bernama sama")
        return self 
      end 
    else
      if total_active_object_with_same_name != 0 
        self.errors.add(:name, "Sudah ada yang bernama sama")
        return self
      end
    end
  end
  
  
  
  def all_base_fields_present? 
    name.present? and
    account_case.present?   
  end
  
  def parent_id_present_for_non_base_account
    return if self.is_base_account? 
    
    if not parent_id.present?  or parent.nil? or  parent.account_case != ACCOUNT_CASE[:group]
      self.errors.add(:parent_id, "Harus ada parent account berupa group account, bukan ledger account")
      return self
    end
  end
  
  def self.active_accounts
    self.where(:is_temporary_account => false )
  end
  
  def valid_account_case
    return if not all_base_fields_present?
    
    if not [
      ACCOUNT_CASE[:group],
      ACCOUNT_CASE[:ledger]
      ].include?(account_case) 
      
      self.errors.add(:account_case, "Harus ledger atau group")
      return self 
    end
  end
  
  
  def self.create_object(params, is_include_code)
    
    new_object                           = self.new 
    new_object.name                      =  ( params[:name].present? ? params[:name   ].to_s.upcase : nil )  
    new_object.parent_id                 = params[:parent_id]
    new_object.account_case              = params[:account_case] 
    new_object.user_id = params[:user_id]
    


    new_object.save 
    
    return new_object
    
  end
  
  def update_object( params, is_include_code ) 
    # puts "=======> Inside update_object\n"*5
    if self.is_base_account? 
      self.errors.add(:generic_errors, "Base Account tidak dapat di update")
      # puts "tidak bisa update base"
      return self 
    end
    
    if self.expenses.count != 0  
      
      self.errors.add(:generic_errors, "Akun sudah memiliki transaksi")
      return self  
    end
    
    
    # puts "inside update_object"
    # puts "the name : #{params[:name]}"
    
    self.name                      =  ( params[:name].present? ? params[:name   ].to_s.upcase : nil )  
    self.parent_id                 = params[:parent_id]
    self.account_case              = params[:account_case] 
   


    self.save 
    
    # puts "Total errors: #{self.errors.size}"
    
    return self
  end
  
  
  
  # http://e27.co/li-ka-shing-teaches-buy-car-house-5-years/
  def self.setup_business(creator)
    self.create_base_objects(creator) #   daily food, other expenses  
  end
  
  def self.create_base_objects(creator)
    self.create_living(creator)
    self.create_working(creator)
    self.create_relationship(creator)
    self.create_personal_development(creator)
  end
  
  def self.create_living(creator)
    new_object = self.new
    new_object.name = "Living" 
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:living]
    new_object.is_base_account = true
    new_object.user_id = creator.id  
    new_object.save 
    return new_object
  end
  
  def self.create_working(creator)
    new_object = self.new
    new_object.name = "Working" 
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:working]
    new_object.is_base_account = true 
    new_object.user_id = creator.id 
    new_object.save 
    return new_object
  end
  
  def self.create_relationship(creator)
    new_object = self.new
    new_object.name = "Relationship" 
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:relationship]
    new_object.is_base_account = true 
    new_object.user_id = creator.id 
    new_object.save 
    return new_object
  end
  
  def self.create_personal_development(creator) 
    new_object = self.new
    new_object.name = "Personal Development" 
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:personal_development]
    new_object.is_base_account = true 
    new_object.user_id = creator.id 
    new_object.save 
    return new_object
  end
  
  def delete_object
    if self.is_base_account?
      self.errors.add(:generic_errors, "Tidak dapat menghapus base account")
      return self 
    end
    
    
    if self.descendants.count != 0 
      self.errors.add(:generic_errors, "Tidak dapat menghapus account ini: ada ledger account")
      return self 
    end
    
    
    if self.account_case == ACCOUNT_CASE[:ledger] and
        self.expenses.count != 0 
      self.errors.add(:generic_errors, "Tidak dapat dihapus karena ada expense berdasar akun ini")
      return self 
    else
      self.destroy 
    end
    
    
  end
   
end
