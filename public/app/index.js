App.IndexRoute = Ember.Route.extend({
    beforeModel: function(a, b, c) {
	console.log("Index-beforeModel", a, b, c);
    },
    model: function(a, b, c) {
	console.log("Index-model", a, b, c);
    },
    actions: {
	search: function(query) {
	    console.log("Index-search:", query);
	    this.transitionTo('index.query', query);
	}
    }
});

App.IndexController = Ember.Controller.extend({
});
