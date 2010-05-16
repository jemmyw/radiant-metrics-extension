module Metrics
  class Playground < Vanity::Playground
    def load!
      @experiments = {}
      @metrics = {}
      
      DbMetric.load_all rescue nil
      AbTest.load_all rescue nil
    end
  end
end