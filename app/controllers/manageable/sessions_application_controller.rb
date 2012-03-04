module Manageable
  class SessionsApplicationController < ActionController::Base
    protect_from_forgery
    layout 'manageable/session'
  end
end