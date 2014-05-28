Ext.define('AM.view.operation.project.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.projectform',

  title : 'Add / Edit ',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
	
  initComponent: function() {
	
	 
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: [
				{
	        xtype: 'hidden',
	        name : 'id',
	        fieldLabel: 'id'
	      }, 
	
				{
	        xtype: 'textfield',
	        name : 'name',
	        fieldLabel: ' Nama Project'
	      },
				{
					xtype: 'textfield',
					name : 'description',
					fieldLabel: 'Deskripsi'
				}
	
			]
    }];

    this.buttons = [{
      text: 'Save',
      action: 'save'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setComboBoxData : function( record){
		// var me = this; 
		// me.setLoading(true);
		// var comboBox = this.down('form').getForm().findField('customer_id'); 
		// var selectedRecordId = record.get("customer_id");
		// 
		// var store = comboBox.store; 
		// store.load({
		// 	params: {
		// 		selected_id : selectedRecordId
		// 	},
		// 	callback : function(records, options, success){
		// 		me.setLoading(false);
		// 		comboBox.setValue( selectedRecordId );
		// 	}
		// });
	}
});

