$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      var question_id = gon.question_id
      this.perform('follow', {id: question_id});
    },

    received: function(data) {
      if (gon.current_user_id != data.answer.user_id) {
        $('.answers').append(JST['templates/answer']({
          answer: data.answer,
          links: data.links,
          rating: data.rating,
          files: data.files,
          class_name: data.class_name,
          question_user_id: data.question_user_id,
          current_user_id: gon.current_user_id
        }))
      }
    }
  });
});
