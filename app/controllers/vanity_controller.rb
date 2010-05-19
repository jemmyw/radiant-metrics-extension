class VanityController < ApplicationController
  use_vanity
  include Metrics::Identity
  include Vanity::Rails::Dashboard
end