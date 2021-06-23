$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId')
    $('form').show();
  })
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow');
    },

    received: function(data) {
      $('.questions').append(data)
    }
  });
});
