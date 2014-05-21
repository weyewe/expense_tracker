class Venue < ActiveRecord::Base
  has_many :expenses 
  
   
  validates_presence_of :name  
  validates_presence_of :user_id 
    
  
  validate :unique_non_deleted_name_on_current_user
  
  
  def unique_non_deleted_name_on_current_user
    return if user_id.nil? or name.nil? 
    
    current_user_id = self.user_id
    current_name = self.name 
    
    total_active_object_with_same_name  = Venue.where(
                        :user_id => current_user_id, 
                        :name => current_name, 
                        :is_deleted => false).count
                        
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
 
  
  def self.create_object( params ) 
    new_object           = self.new
    new_object.name    =  ( params[:name].present? ? params[:name].to_s.upcase : nil )  
    new_object.description  = params[:description]
    new_object.user_id      = params[:user_id    ] 
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    self.name    =  ( params[:name].present? ? params[:name   ].to_s.upcase : nil  ) 
    self.description  = params[:description]
    self.user_id      = params[:user_id    ] 
    self.save
    
    return self
  end
  
  def delete_object
    
    if self.expenses.where(:is_deleted => false ).count != 0 
      self.errors.add(:generic_errors, "Sudah ada expense dengan venue ini")
      return self 
    end
    
    self.is_deleted  = true 
    self.save   
  end 
  
  
  def self.active_objects
    self.where(:is_deleted => false )
  end
  
  
  
  
end
