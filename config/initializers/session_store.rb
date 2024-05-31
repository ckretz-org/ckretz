# Configurations
session_url = "#{ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379')}/0/session"
secure = Rails.env.production?
name = Rails.application.class.module_parent_name.downcase
key = Rails.env.production? ? "_#{name}_session" : "_#{name}_session_#{Rails.env}"
domain = ENV.fetch("DOMAIN_NAME", "localhost")

Rails.application.config.session_store :redis_store,
                                       url: session_url,
                                       expire_after: 15.minutes,
                                       key: key,
                                       domain: domain,
                                       threadsafe: true,
                                       secure: secure,
                                       same_site: :lax,
                                       httponly: true
