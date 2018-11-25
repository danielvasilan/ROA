

Ext.define('RoaApp.view.main.filterForm', {
    extend: 'Ext.form.Panel',
	height: 350,
    width: 300,
	defaultType: 'textfield',

    xtype: 'filterform',

    requires: [
    ],

    title: 'Filter',

    items: [
        {
            fieldLabel: 'First Name',
            name: 'firstName'
        },
        {
            fieldLabel: 'Last Name',
            name: 'lastName'
        },
        {
            xtype: 'datefield',
            fieldLabel: 'Date of Birth',
            name: 'birthDate'
        }
    ]


});
