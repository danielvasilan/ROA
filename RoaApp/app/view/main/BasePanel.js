Ext.define('RoaApp.view.main.basePanel', {
    extend: 'Ext.Container',
	layout: {
        type: 'hbox',
        align: 'middle'
    },
    xtype: 'basepanel',

    title: 'Basic Panel',
	
	items: [
		{
			docked: 'top',
            
			items: [
				{
					defaultType: 'textfield',
					layout: {
						type: 'hbox',
						align: 'middle'
					},
					items: [
						{
							xtype: 'button',
							text: 'Change filter',
							id: 'filter-button'
						},
						{
							xtype: 'button',
							text: 'Actiuni',
							iconCls: 'fa-cog',
							id: 'actions-button'
						},
						{
							xtype: 'label',
        forId: 'filter-button',
        text: 'My Awesome Field',
        margin: '0 0 0 10'
							
						}
						
					]
				}
				,
				{
					xtype: 'tabpanel'
					
				}
              ]
          }
	]

    
});
