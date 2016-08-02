# coding: utf-8
module Spree
  class PaymentMailer < BaseMailer

    def error_notification(subject, message)
      mail(to: ENV['ADMIN_EMAILS'].split(","), subject: subject, body: message)
    end

  end
end