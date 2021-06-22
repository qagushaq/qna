$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      var question_id = gon.question_id
      this.perform('follow', {id: question_id});
    },

    received: function(data) {
      if (gon.current_user_id != data.comment.user_id) {
        var commentedId = data.commented_id
        $('.comments-' + commentedId).append(JST['templates/comment']({
          comment: data.comment,
          user: data.user
        }))
      }
    }
  });
});
