Ext.define('AM.view.operation.expense.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.expenseform',

  title : 'Add / Edit ',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
	
  initComponent: function() {
	
	
		var ProjectRemoteJsonStore = Ext.create(Ext.data.JsonStore, {
			storeId : 'project_search',
			fields	: [
				{
					name : 'project_name',
					mapping  :'name'
				},
				{
					name : 'project_id',
					mapping : 'id'
				},
				{
					name : 'project_description',
					mapping : 'description'
				}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_project',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			}
		});
	 
	
		var VenueRemoteJsonStore = Ext.create(Ext.data.JsonStore, {
			storeId : 'venue_search',
			fields	: [
				{
					name : 'venue_name',
					mapping  :'name'
				},
				{
					name : 'venue_id',
					mapping : 'id'
				},
				{
					name : 'venue_description',
					mapping : 'description'
				}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_venue',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			}
		});
		
		var AccountRemoteJsonStore = Ext.create(Ext.data.JsonStore, {
			storeId : 'account_search',
			fields	: [
				{
					name : 'account_name',
					mapping  :'name'
				},
				{
					name : 'account_id',
					mapping : 'id'
				} 
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_account',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			}
		});
		
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
	        fieldLabel: 'Tujuan'
	      },
				{
					xtype: 'textfield',
					name : 'description',
					fieldLabel: 'Penjelasan'
				},
				{
					fieldLabel: 'Kategori Biaya',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'account_name',
					valueField : 'account_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : AccountRemoteJsonStore, 
					listConfig : {
						getInnerTpl: function(){
							return '<div data-qtip="{text}">' +  
												'<div class="combo-name">{account_name}</div>' 
										 '</div>'; 
						}
					},
					name : 'account_id' 
				},
				
				{
					xtype: 'textfield',
					name : 'amount',
					fieldLabel: 'Jumlah'
				},
				
				{
					xtype: 'datefield',
					name : 'expensed_at',
					fieldLabel: 'Tanggal',
					format: 'Y-m-d',
				},
				{
					xtype: 'fieldset',
					title : "Details",
					items: [
						{
							fieldLabel: 'Project',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'project_name',
							valueField : 'project_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : ProjectRemoteJsonStore, 
							listConfig : {
								getInnerTpl: function(){
									return '<div data-qtip="{text}">' +  
														'<div class="combo-name">{project_name}</div>' + 
														'<div>{project_description}</div>'  + 
												 '</div>'; 
								}
							},
							name : 'project_id' 
						}, 
						{
							fieldLabel: 'Venue',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'venue_name',
							valueField : 'venue_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : VenueRemoteJsonStore, 
							listConfig : {
								getInnerTpl: function(){
									return '<div data-qtip="{text}">' +  
														'<div class="combo-name">{venue_name} </div>' + 
														'<div>{venue_description}</div>' +  
												 '</div>'; 
								}
							},
							name : 'venue_id' 
						}
					]
				},
				
	
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

