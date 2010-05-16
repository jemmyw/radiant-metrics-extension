module Metrics
  # Override vanity loading to load
  # metrics and experiments from the database.
  class Playground < ::Vanity::Playground
    def load!
      @experiments = {}
      @metrics = {}
      
      DbMetric.load_all rescue nil
      AbTest.load_all rescue nil
    end
  end
end