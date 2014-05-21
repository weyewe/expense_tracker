class Api::TypesController < Api::BaseApiController
  
  def index
    
    if params[:livesearch].present? 
      livesearch = "%#{params[:livesearch]}%"
      @objects = Type.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch ) 
        )
        
      }.page(params[:page]).per(params[:limit]).order("id DESC")
      
      @total = Type.where{
        (is_deleted.eq false) & 
        (
          (name =~  livesearch )  
        )
        
      }.count
    else
      @objects = Type.active_objects.page(params[:page]).per(params[:limit]).order("id DESC")
      @total = Type.active_objects.count
    end
    
    
    
    # render :json => { :types => @objects , :total => @total, :success => true }
  end

  def create
    @object = Type.create_object( params[:type] )  
    
    
 
    if @object.errors.size == 0 
      render :json => { :success => true, 
                        :types => [@object] , 
                        :total => Type.active_objects.count }  
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

  def update
    
    @object = Type.find_by_id params[:id] 
    @object.update_object( params[:type])
     
    if @object.errors.size == 0 
      render :json => { :success => true,   
                        :types => [@object],
                        :total => Type.active_objects.count  } 
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
    @object = Type.find(params[:id])
    @object.delete_object

    if @object.is_deleted
      render :json => { :success => true, :total => Type.active_objects.count }  
    else
      render :json => { :success => false, :total => Type.active_objects.count }  
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
      @objects = Type.where{ (name =~ query)   
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
                        
      @total = Type.where{ (name =~ query)  
                              }.count
    else
      @objects = Type.where{ (id.eq selected_id)  
                              }.
                        page(params[:page]).
                        per(params[:limit]).
                        order("id DESC")
   
      @total = Type.where{ (id.eq selected_id)   
                              }.count 
    end
    
    
    render :json => { :records => @objects , :total => @total, :success => true }
  end
end
