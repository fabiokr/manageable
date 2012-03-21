require "rails"
require "jquery-rails"
require "sass-rails"

module Manageable
  class Engine < Rails::Engine
  end
end

require "manageable/models/acts_as_article"
require "manageable/controllers/pageable"
require "manageable/helpers/box_builder"
require "manageable/helpers/navigation_builder"
require "manageable/helpers/form_builder"
require "manageable/helpers/attributes_builder"