Ext.define('AM.store.Venues', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Venue'],
	model: 'AM.model.Venue',
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
