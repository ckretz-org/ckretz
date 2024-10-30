# Configurations
return if Rails.env.test?

secure = Rails.env.production?
name = Rails.application.class.module_parent_name.downcase
key = Rails.env.production? ? "_#{name}_session" : "_#{name}_session_#{Rails.env}"
domain = ENV.fetch("DOMAIN_NAME", "www.example.com")

Rails.application.config.session_store :cookie_store,
                                       **{
                                         expire_after: 15.minutes,
                                         key: key,
                                         domain: domain,
                                         threadsafe: true,
                                         secure: secure,
                                         same_site: :lax,
                                         httponly: true
                                       }
