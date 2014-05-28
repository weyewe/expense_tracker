Ext.define('AM.model.Venue', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' } 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/venues',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'venues',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { venue : record.data };
				}
			}
		}
	
  
});
