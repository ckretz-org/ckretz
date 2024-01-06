  class UserMailerPreview < ActionMailer::Preview
    def register_email
      UserMailer.with(user: User.first).register_email
    end
  end
