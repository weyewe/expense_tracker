class Expense < ActiveRecord::Base
  has_many :expense_allocations
  has_many :contacts 
  belongs_to :project
  belongs_to :venue 
  belongs_to :account
  belongs_to :user
  
  validates_presence_of :name  
  validates_presence_of :user_id 
  validates_presence_of :account_id 
  validates_presence_of :expensed_at
  validates_presence_of :amount
  
  
  validate :valid_project_id 
  validate :valid_venue_id
  
  validate :valid_user_id
  validate :valid_account_id
  
  validate :amount_not_zero
  
  def amount_not_zero
    return if not self.amount.present? 
    
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Tidak boleh 0")
      return self 
    end
  end
  
  def valid_user_id
    assigned_user =  User.find_by_id user_id
    
    if assigned_user.nil?
      self.errors.add(:user_id , "Harus ada dan valid")
      return self
    end
  end
  
  def valid_account_id
    return if not user_id.present? 
    return if not account_id.present? 
    
    
    assigned_user =  User.find_by_id user_id
    if not assigned_user.nil?
      assigned_account = user.accounts.where(:id => account_id).first
      puts ">>>>>>>> total account: #{user.accounts.where(:id => account_id).count}"
      puts "User_ud #{user_id}"
      if assigned_account.nil?
        self.errors.add(:account_id , "Harus ada dan valid, bukan #{account_id}")
        return self
      end
    end
    
    
  end
  
  def valid_project_id 
    
    begin
      object = Project.find_by_id project_id 
    rescue => ex
      self.errors.add(:project_id , "Harus dipilih jika ada memang ada project")
      return self 
    end
  end
  
  def valid_venue_id 
    
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
    
    new_object.amount  = params[:amount].present? ? BigDecimal( params[:amount]) : nil 
    
    new_object.expensed_at  = params[:expensed_at    ] 
    new_object.account_id   = params[:account_id    ]
    
    new_object.project_id   = params[:project_id    ]
    
    new_object.venue_id     = params[:venue_id      ] 
    
    new_object.user_id = params[:user_id]
    
    new_object.save
    
    return new_object
  end
  
  
   
  
  def update_object(params)
    self.name    =   params[:name] 
    self.description  = params[:description]
    self.amount  = params[:amount].present? ? BigDecimal( params[:amount]) : nil 
    
    self.expensed_at  = params[:expensed_at    ] 
    self.account_id   = params[:account_id    ]
    
    self.project_id   = params[:project_id    ]
    
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
