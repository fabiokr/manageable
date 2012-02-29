module Manageable
  class SessionsController < ActionController::Base
    protect_from_forgery
    layout 'manageable/session'
  end
end