Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: '404'
  waitOn: ->
    Meteor.subscribe 'posts'

Router.route '/', name: 'postsList'

Router.route '/posts/:_id',
  name: 'postPage'
  data: ->
    Posts.findOne this.params._id

Router.route '/posts/:_id/edit',
  name: 'postEdit'
  waitOn: ->
    Meteor.subscribe 'comments', @.params._id
  data: ->
    Posts.findOne @params._id

Router.route '/submit',
  name: 'postSubmit'

requireLogin = ->
  unless Meteor.user()
    @render 'accessDenied'
  else
    @next()

Router.onBeforeAction 'dataNotFound', only: 'postPage'
Router.onBeforeAction requireLogin, only: 'postSubmit'