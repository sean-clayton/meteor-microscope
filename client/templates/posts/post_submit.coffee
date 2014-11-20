Template.postSubmit.events 'submit form': (e) ->
  e.preventDefault()

  post =
    url: $(e.target).find('[name=url]').val()
    title: $(e.target).find('[name=title]').val()

  errors = validatePost post
  return Session.set 'postSubmitErrors', errors if errors.title or errors.url

  Meteor.call 'postInsert', post, (error, result) ->

    # Display the error to user and abort
    return throwError error.reason if error
    Router.go 'postPage',
      _id: result._id

    # Show this result but route anyway
    return throwError 'This link has already been posted' if result.postExists

    return

  return

Template.postSubmit.created = ->
  Session.set 'postSubmitErrors', {}
  return

Template.postSubmit.helpers
  errorMessage: (field) ->
    Session.get('postSubmitErrors')[field]

  errorClass: (field) ->
    (if !!Session.get('postSubmitErrors')[field] then 'has-error' else '')
