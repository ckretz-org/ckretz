class SecretSubscriber < ActiveSupport::Subscriber
  attach_to :secret

  def created(event)
    secret = event.payload[:secret]
    EmbedSecretJob.perform_later(id: secret.id)
  end

  def updated(event)
    secret = event.payload[:secret]
    EmbedSecretJob.perform_later(id: secret.id)
  end
end
