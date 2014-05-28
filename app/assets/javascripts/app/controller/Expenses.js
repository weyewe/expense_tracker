Ext.define('AM.controller.Expenses', {
  extend: 'Ext.app.Controller',

  stores: ['Expenses'],
  models: ['Expense'],

  views: [
    'operation.expense.List',
    'operation.expense.Form'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'expenselist'
		} 
	],

  init: function() {
    this.control({
      'expenselist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'expenseform button[action=save]': {
        click: this.updateObject
      },
      'expenselist button[action=addObject]': {
        click: this.addObject
      },
      'expenselist button[action=editObject]': {
        click: this.editObject
      },
      'expenselist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			'expenselist textfield[name=searchField]': {
				change: this.liveSearch
			}
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getExpensesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getExpensesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('expenseform');
    view.show();
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('expenseform');

    view.down('form').loadRecord(record);
		view.setComboBoxData(record); 
  },

  updateObject: function(button) {
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getExpensesStore();
    var record = form.getRecord();
    var values = form.getValues();

		
		if( record ){
			record.set( values );
			 
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
					win.close();
				},
				failure : function(record,op ){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.Expense( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
					form.setLoading(false);
					win.close();
					
				},
				failure: function( record, op){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },

  deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getExpensesStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically
		this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  }

});
