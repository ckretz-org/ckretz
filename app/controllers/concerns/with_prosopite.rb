module WithProsopite
  extend ActiveSupport::Concern
  included do
    unless Rails.env.production?
      around_action :n_plus_one_detection

      def n_plus_one_detection
        Prosopite.scan
        yield
      ensure
        Prosopite.finish
      end
    end
  end
end
