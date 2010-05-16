class VanityController < ApplicationController
  use_vanity
  include Vanity::Rails::Dashboard
end