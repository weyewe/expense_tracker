json.success true 
json.total @total
json.records @objects do |object|
	json.id 										object.id
	json.type_name 						object.type.name
	json.code 			object.code 
	
end

