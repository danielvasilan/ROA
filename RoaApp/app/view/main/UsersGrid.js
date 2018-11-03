/**
 * This view is an example list of people.
 */
Ext.define('RoaApp.view.main.usersgrid', {
    extend: 'Ext.grid.Panel',
    xtype: 'usersgrid',

    requires: [
        'RoaApp.store.AppUsers'
    ],

    title: 'App Users',

    store: {
        type: 'appusers'
    },

    columns: [
        { text: 'User Code',  dataIndex: 'USER_CODE' },
		{ text: 'Nume',  dataIndex: 'NUME' },
        { text: 'Prenume', dataIndex: 'PRENUME', flex: 1 },
        { text: 'pwd', dataIndex: 'PWD', flex: 1 }
    ],

    listeners: {
        //select: 'onItemSelected'
    }
});
