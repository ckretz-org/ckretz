class WelcomeEmailSubscriber < ActiveSupport::Subscriber
  attach_to :user

  def created(event)
    user = event.payload[:user]
    UserMailer.with(user: user).register_email.deliver_later
  end
end
