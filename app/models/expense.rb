class Expense < ActiveRecord::Base
  has_many :expense_allocations
  has_many :contacts 
  
  validates_presence_of :name  
  validates_presence_of :user_id 
  validates_presence_of :account_id 
  
  
  validate :valid_project_id_if_present
  validate :valid_venue_id_if_present
  
  def valid_project_id_if_present
    return if not is_project_id_present   
    
    begin
      object = Project.find_by_id project_id 
    rescue => ex
      self.errors.add(:project_id , "Harus dipilih jika ada memang ada project")
      return self 
    end
  end
  
  def valid_venue_id_if_present
    return if not is_venue_id_present   
    
    begin
      object = Venue.find_by_id venue_id 
    rescue => ex
      self.errors.add(:venue_id , "Harus dipilih jika ada memang ada venue")
      return self 
    end
  end
  
  
   
 
  
  def self.create_object( params ) 
    new_object           = self.new
    new_object.name    =   ( params[:name].present? ? params[:name].to_s.upcase : nil )  
    new_object.description  = params[:description]
    
    new_object.expensed_at  = params[:user_id    ] 
    new_object.account_id   = params[:account_id    ]
    
    new_object.is_project_id_present = params[:is_project_id_present]
    new_object.project_id   = params[:project_id    ]
    
    new_object.is_venue_id_present = params[:is_venue_id_present]
    new_object.venue_id     = params[:venue_id      ] 
    
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    self.name    =   params[:name] 
    self.description  = params[:description]
    
    self.expensed_at  = params[:user_id    ] 
    self.account_id   = params[:account_id    ]
    
    self.is_project_id_present = params[:is_project_id_present]
    self.project_id   = params[:project_id    ]
    
    self.is_venue_id_present = params[:is_venue_id_present]
    self.venue_id     = params[:venue_id      ]
    
    self.save
    
    return self
  end
  
  def delete_object
    
    if self.expenses.where(:is_deleted => false ).count != 0 
      self.errors.add(:generic_errors, "Sudah ada expense dengan expense ini")
      return self 
    end
    
    
    self.is_deleted  = true 
    self.save  
    
  end 
  
  
  def self.active_objects
    self.where(:is_deleted => false )
  end
  
end
