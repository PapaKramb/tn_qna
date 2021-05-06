import consumer from "./consumer"

$(document).on('turbolinks:load',function(){
  const questionId = $('.question').data('id');
  let answersList = $('.answers');
  let template = require('./templates/answers.hbs')
  consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to answers')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.user_id != data.user_id )
      {
        answersList.append(template(data)).hide().fadeIn();
      }
    }
  });
});