# -*- encoding : utf-8 -*-
class NotifyMailer < ActionMailer::Base
  default from: "service@tbs-info.com"

  def send_mail(mailto, subject, body)
    mail(:to => mailto,
         :subject => subject,
         :body => body)
  end

  def send_mail_delay(mailto, subject, body)
    NotifyMailer.delay.send_mail(mailto, subject, body)
  end
end
