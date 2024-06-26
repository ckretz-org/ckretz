class EmbedSecretJob < ApplicationJob
  queue_as :default

  def perform(*args)
    unless FeatureFlagging.fetch_boolean_flag(key: "embed-secrets")
      Rails.logger.warn("EmbedSecretJob: #{args.first[:id]} - FeatureFlagging Embed secrets is disabled.")
      return if Rails.env.production?
    end
    secret = RLS.disable_for_block do
      Secret.find(args.first[:id])
    end
    uri = URI(ENV.fetch("OLLAMA_EMBEDDING_URL", "http://localhost:11434/api/embeddings"))
    body = {
      model: ENV.fetch("OLLAMA_EMBEDDING_MODEL", "nomic-embed-text"),
        prompt: secret.name
      }
    headers = { 'Content-Type': "application/json" }
    response = Net::HTTP.post(uri, body.to_json, headers)
    raise "Failed to embed secret: #{response.body}" unless response.code == "200"

    json = JSON.parse(response.body)
    RLS.disable_for_block do
      secret.update(embedding: json["embedding"])
    end
  end
end
