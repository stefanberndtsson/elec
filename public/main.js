function loadScript(name) {
    var url = 'app/'+name+'.js';
    console.log("loadScript:", url);
    $.ajaxSetup({async: false});
    $.getScript(url);
    $.ajaxSetup({async: true});
}

function loadTemplate(name) {
    var url = 'templates/'+name+'.hb';
    console.log("loadTemplate:", url);
    $.ajaxSetup({async: false});
    $.get(url).done(function(tmpl) {
	Ember.Handlebars.bootstrap('<div><script type="text/x-handlebars" data-template-name="'+name+'">'+tmpl+'</script></div>');
    });
    $.ajaxSetup({async: true});
}

function apiGet(url, options) {
    return new Ember.RSVP.Promise(function(resolve, reject) {
        var options = options || {
            type: 'GET',
            cache: false,
            dataType: 'json',
            contentType: 'application/json'
        };

        options.success = function(data){
	    console.log("apiGet-success:", data);
            resolve(data);
        };

        options.error = function(jqXHR, status, error){
	    console.log("apiGet-error:", status);
            reject(arguments);
        };

        Ember.$.ajax(url, options);
    });
};

function setup() {
    loadScript('index');
    loadScript('index/query');
    loadTemplate('index');
    loadTemplate('index/query');
}

App = Ember.Application.create({  
    rootElement: '#elec',
});

App.Router.map(function() {
    this.resource('index', {path: '/'}, function() {
	this.route('query', {path: '/query/:query'});
    });
});

setup();
