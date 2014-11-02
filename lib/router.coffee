Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    return Meteor.subscribe 'posts'

Router.route '/',
  name: 'postsList'
