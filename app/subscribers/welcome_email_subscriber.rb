class WelcomeEmailSubscriber < ActiveSupport::Subscriber
  attach_to :user

  def created(event)
    user = event.payload[:user]
    mail = UserMailer.with(user: user).register_email
    mail.deliver_later
  end
end
