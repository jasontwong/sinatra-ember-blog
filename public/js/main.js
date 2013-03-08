(function($) {
  "use strict";
  $(function() {
    window.App = Em.Application.create({
      LOG_TRANSITIONS: true
    });
    // {{{ routes
    App.Router.map(function() {
      this.route('about');
      this.route('favorites', { path: '/favs' });
      this.resource('posts', function() {
        this.route('new');
        this.route('post', { path: '/:post_id' });
      });
    });

    App.Router.reopen({
      location: 'history'
    });
    App.IndexRoute = Em.Route.extend({
      setupController: function(controller) {
        this.controllerFor('application').set('docTitle', '');
      }
    });
    App.AboutRoute = Em.Route.extend({
      setupController: function(controller) {
        this.controllerFor('application').set('docTitle', 'About');
      }
    });
    App.PostsIndexRoute = Em.Route.extend({
      setupController: function(controller, posts) {
        this.controllerFor('application').set('docTitle', 'Posts');
        controller.set('content', posts);
      },
      model: function(params) {
        return App.Post.find({ is_published: true });
      }
    });
    // }}}
    // {{{ controllers
    App.ApplicationController = Em.Controller.extend({
      name: 'Blog',
      docTitle: 'Blog',
      title: ''
    });
    App.ApplicationController.reopen({
      docTitleChanged: Em.observer(function() {
        var title = this.get('name'),
          docTitle = this.get('docTitle');
        if (docTitle.length) {
          title = docTitle + ' - ' + title;
        }
        $(document).attr('title', title);
      }, 'docTitle')
    });
    App.PostsNewController = Em.Controller.extend({
      publishPost: function() {
        console.log('publish');
        var post = this.get('post');
        post.isPublished = !post.isPublished;
        this.set('post', post);
      },
      create: function() {
        console.log(this.get('title'));
      }
    });
    // }}}
    // {{{ views
    App.SidebarView = Em.View.extend();
    App.PostsNewView = Em.View.extend({
      /*
      post: null,
      create: function() {
        console.log(this.get('excerpt').get('value'));
        var data = {
          title: this.get('title').get('value'),
          content: this.get('content').get('value'),
          excerpt: this.get('excerpt').get('value'),
          isPublished: this.get('excerpt').get('value')
        };
        this.post.createPost(data);
      },
      publishPost: function() {
      }
      */
    });
    // }}}
    // {{{ stores
    App.Store = DS.Store.extend({
      revision: 12
    });
    // }}}
    // {{{ models
    App.Post = DS.Model.extend({
      title: DS.attr('string'),
      slug: DS.attr('string'),
      content: DS.attr('string'),
      excerpt: DS.attr('string'),
      publishDate: DS.attr('date'),
      isPublished: DS.attr('boolean')
    });
    // }}}
    App.initialize();
  });
}(jQuery));
