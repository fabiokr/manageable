require "rails"

module Manageable
  class Engine < Rails::Engine
  end
end

require "manageable/controllers/pageable"
require "manageable/helpers/box_builder"
require "manageable/helpers/navigation_builder"
require "manageable/helpers/form_builder"