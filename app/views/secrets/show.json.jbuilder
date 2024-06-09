json.partial! "secrets/secret", secret: @secret
json.values @secret.secret_values_hash
