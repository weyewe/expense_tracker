class Api::ExpensesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Expense.includes(:account, :project, :venue).active_objects.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )  
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Expense.active_objects.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch ) 
        )
        
      }.count
    else
      @objects = Expense.includes(:account, :project, :venue).active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Expense.active_objects.count
    end
    
    
    
    # render :json => { :expenses => @objects , :total => @total, :success => true }
  end

  def create
    
    params[:expense][:expensed_at] =  parse_date( params[:expense][:expensed_at] )
    params[:expense][:user_id] =  current_user.id 
    @object = Expense.create_object( params[:expense] )  
    
    
 
    if @object.errors.size == 0 
      puts "no error"
      render :json => { :success => true, 
                        :expenses => [
                          :id 				    => 			@object.id              ,
                        	:name				    => 			@object.name            ,
                        	:description    => 			@object.description     ,
                        	:amount 		    => 			@object.amount          ,
                        	:account_id     => 			@object.account_id      ,
                        	:account_name   => 			@object.account.name    ,
                        	:project_id     => 			@object.project_id      ,
                        	:project_name   => 			@object.project.name    ,
                        	:venue_id 	    => 			@object.venue_id        ,
                        	:venue_name     => 			@object.venue.name      ,
                        	:expensed_at    => format_date_friendly( @object.expensed_at )
                          
                          
                          ] , 
                        :total => Expense.active_objects.count }  
    else
      puts "Some error"
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg                         
    end
  end

  def update
    
    @object = Expense.find_by_id params[:id] 
    
    params[:expense][:expensed_at] =  parse_date( params[:expense][:expensed_at] )
    @object.update_object( params[:expense])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :expenses => [@object],
                        :total => Expense.active_objects.count  } 
    else
      msg = {
        :success => false, 
        :message => {
          :errors => extjs_error_format( @object.errors )  
        }
      }
      
      render :json => msg 
    end
  end

  def destroy
    @object = Expense.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => Expense.active_objects.count }  
    else
      render :json => { :success => false, :total => Expense.active_objects.count }  
    end
  end
  
  def search
    search_params = params[:query]
    selected_id = params[:selected_id]
    if params[:selected_id].nil?  or params[:selected_id].length == 0 
      selected_id = nil
    end
    
    query = "%#{search_params}%"
    # on PostGre SQL, it is ignoring lower case or upper case 
    
    if  selected_id.nil?
      @objects = Expense.active_objects.where{ (name =~ query)   
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Expense.active_objects.where{ (name =~ query)  
                              }.count
    else
      @objects = Expense.active_objects.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Expense.active_objects.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
