Ext.define('RoaApp.store.AppUsers', {
    extend: 'Ext.data.Store',

    alias: 'store.appusers',

    fields: [
        'USER_CODE', 'NUME', 'PRENUME', 'PWD'
    ],

    proxy: {
        type: 'ajax',
		method: "POST",
		url: '/roaapp/php/getJsonFromQuery.php',
		extraParams:{
			sql: "SELECT USER_CODE, NUME, PRENUME, PWD FROM APP_USER"
		},
		reader: {
			type: 'json',
			rootProperty: 'data'
			}
		}
	,
	autoLoad: true
});
