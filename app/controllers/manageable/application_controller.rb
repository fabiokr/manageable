module Manageable
  class ApplicationController < ActionController::Base
    protect_from_forgery

    layout 'manageable/application'
  end
end