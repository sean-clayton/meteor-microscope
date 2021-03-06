@Posts = new Mongo.Collection 'posts'

Posts.allow
  update: (userId, post) ->
    ownsDocument userId, post
  remove: (userId, post) ->
    ownsDocument userId, post

Posts.deny
  update: (userId, post, filedNames) ->
    # Only edit these fields
    _.without(fieldNames, 'url', 'title').length > 0

@validatePost = (post) ->
  errors = {}
  if !post.title then errors.title = 'Please fill in a headline'
  if !post.url then errors.url = 'Please fill in a URL'
  errors

Meteor.methods
  postInsert: (postAttributes) ->
    check Meteor.userId(), String
    check postAttributes,
      title: String
      url: String

    errors = validatePost(postAttributes)
    throw new Meteor.Error 'invalid-post', 'You must set a title and URL for your post' if errors.title or errors.url

    postWithSameLink = Posts.findOne url: postAttributes.url
    if postWithSameLink
      return (
        postExists: true
        _id: postWithSameLink._id
      )

    user = Meteor.user()

    post = _.extend postAttributes,
      userId: user._id
      author: user.username
      submitted: new Date()
      commentsCount: 0

    postId = Posts.insert post

    _id: postId
