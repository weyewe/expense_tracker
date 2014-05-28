Ext.define('AM.model.Expense', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' },
			{ name: 'amount', type: 'string' },
			
			
			{ name: 'account_id', type: 'int' },
			{ name: 'account_name', type: 'string' },
			
			{ name: 'venue_id', type: 'int' },
			{ name: 'venue_name', type: 'string' },
			
			{ name: 'project_id', type: 'int' },
			{ name: 'project_name', type: 'string' },
			
			{ name: 'expensed_at', type: 'string' },
			  
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/expenses',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'expenses',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { expense : record.data };
				}
			}
		}
	
  
});
