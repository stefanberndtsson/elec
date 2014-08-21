App.IndexQueryRoute = Ember.Route.extend({
    beforeModel: function(a, b, c) {
	console.log("IndexQuery-beforeModel", a, b, c);
    },
    model: function(params) {
	this.controllerFor('index').set('query', params.query);
	console.log("IndexQuery-model", params);
	return Ember.RSVP.hash({
	    query: apiGet('/elec/?search='+params.query)
	});
    }
});

App.FileLinkComponent = Ember.Component.extend({
    tagName: 'a',
    layout: Ember.Handlebars.compile('<span>{{name}}</span>'),
    attributeBindings: ['href', 'target'],
    target: '_blank',
    href: function() {
	return '/file/'+this.get('item.id');
    }.property('item'),
    name: function() {
	return this.get('item.name');
    }.property('item')
});
