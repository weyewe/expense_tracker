Ext.define('AM.model.Project', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'address', type: 'string' },
			
    	{ name: 'pic', type: 'string' } ,
			{ name: 'contact', type: 'string' } ,
			{ name: 'email', type: 'string' }
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/projects',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'projects',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { project : record.data };
				}
			}
		}
	
  
});
