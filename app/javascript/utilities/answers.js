$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
      e.preventDefault();
      $(this).hide();
      const answerId = $(this).data('answerId');
      $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('form.new-answer').on('ajax:success', function(e){
      const answer = e.detail[0].answer;

      $('.answers').append('<p>' + answer.body + '</p>');
  })
      .on('ajax:error', function(e){
          const errors = e.detail[0];

          $.each(errors, function(index, value){
              $('.answer-errors').append('<p>' + value + '</p>');
          })
      })
});
