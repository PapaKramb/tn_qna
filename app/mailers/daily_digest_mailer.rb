class DailyDigestMailer < ApplicationMailer
  def digest(user, today_questions)
    @today_questions = today_questions
    mail to user.email
  end
end
