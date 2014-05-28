
json.success true 
json.total @total
json.expenses @objects do |object|
	json.id 								object.id  
 
	 
	json.name								object.name
	json.description				object.description
	json.amount 						object.amount

	json.account_id 				object.account_id 
	json.account_name 			object.account.name 

	json.project_id 				object.project_id 
	json.project_name 			object.project.name 

	json.venue_id 					object.venue_id
	json.venue_name 				object.venue.name 

	json.expensed_at  format_date_friendly( object.expensed_at ) 

end


