# coding: utf-8
Spree::OrderMailer.class_eval do

    def error_notification(subject, message)
      mail(to: ENV['ADMIN_EMAILS'].split(","), subject: subject, body: message)
    end

end