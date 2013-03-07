(function($) {
  "use strict";
  $(function() {
    var App = Ember.Application.create({
      LOG_TRANSITIONS: true
    });
    // {{{ router
    App.Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
      this.resource('posts', function() {
        this.route('new');
      });
    });

    App.Router.reopen({
      location: 'history'
    });
    // }}}
    App.IndexRoute = Ember.Route.extend({
      setupController: function(controller) {
        this.controllerFor('application').set('docTitle', '');
      }
    });
    App.AboutRoute = Ember.Route.extend({
      setupController: function(controller) {
        this.controllerFor('application').set('docTitle', 'About');
      }
    });

    App.ApplicationController = Ember.Controller.extend({
      name: 'Blog',
      docTitle: 'Blog',
      title: ''
    });
    App.ApplicationController.reopen({
      docTitleChanged: Ember.observer(function() {
        var title = this.get('name'),
          docTitle = this.get('docTitle');
        if (docTitle.length) {
          title = docTitle + ' - ' + title;
        }
        $(document).attr('title', title);
      }, 'docTitle')
    });
    App.initialize();
  });
}(jQuery));
