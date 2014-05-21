Ext.define('AM.store.Types', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Type'],
	model: 'AM.model.Type',
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
