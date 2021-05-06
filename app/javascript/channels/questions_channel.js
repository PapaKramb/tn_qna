import consumer from "./consumer"

$(document).on('turbolinks:load',function(){
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to question')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.user_id != data.user_id)
      {
        const Handlebars = require("handlebars");
        let source= "<div class='question-id-{{{ question.id }}}'> <p>{{{question.title}}} {{{question.body}}}</p> </div>"
        let resource = Handlebars.compile(source);
        $('.questions').append(resource(data))
      }
    }
  });
});