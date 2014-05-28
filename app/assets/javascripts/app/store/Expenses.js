Ext.define('AM.store.Expenses', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Expense'],
	model: 'AM.model.Expense',
	// autoLoad: {start: 0, limit: this.pageSize},
	autoLoad : false, 
	autoSync: false,
	pageSize : 10, 
	
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 
	listeners: {

	} 
});
