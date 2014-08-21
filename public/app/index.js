App.IndexRoute = Ember.Route.extend({
    beforeModel: function(a, b, c) {
	console.log("Index-beforeModel", a, b, c);
    },
    model: function(a, b, c) {
	console.log("Index-model", a, b, c);
    },
    actions: {
	search: function() {
	    console.log("Index-search:", this.controller.get('search_query'));
	    this.transitionTo('index.query', this.controller.get('search_query'));
	}
    }
});

App.IndexController = Ember.Controller.extend({
    search_query: null
});
