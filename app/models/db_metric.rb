class DbMetric < ActiveRecord::Base
  class << self
    def load_all
      DbMetric.all.each do |db_metric|
        db_metric.load
      end
    end
  end
  
  validates_presence_of :name

  after_create :load

  def load
    Vanity.playground.metrics[metric_id] = metric
  end

  def metric_id
    name.parameterize.to_s.underscore.to_sym unless new_record?
  end

  def count
    new_record? ? 0 : metric.values(created_at, Time.now).sum
  end

  def metric
    @metric ||= begin
      metric = Vanity::Metric.new(Vanity.playground, name, metric_id)
      metric.description(self.description)
      metric
    end
  end
end
