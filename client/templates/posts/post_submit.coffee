Template.postSubmit.events 'submit form': (e) ->
  e.preventDefault()
  post =
    url: $(e.target).find('[name=url]').val()
    title: $(e.target).find('[name=title]').val()

  Meteor.call 'postInsert', post, (error, result) ->
    # Display the error to user and abort

    return alert error.reason if error
    Router.go 'postPage', _id: result._id

    return

  return
