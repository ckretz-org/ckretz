class SlowQuerySubscriber < ActiveSupport::Subscriber
  SECONDS_THRESHOLD = ENV.fetch("SLOW_QUERY_THRESHOLD", 0.1).to_f
  unless Rails.env.production?
    ActiveSupport::Notifications.subscribe("sql.active_record") do |name, start, finish, _, data|
      duration = finish - start
      if duration > SECONDS_THRESHOLD
        Rails.logger.warn "[#{name}], #{duration}, slow_query: #{data[:sql]}"
      end
    end
  end
end
