class SessionsController < Manageable::SessionsApplicationController

  def index
    flash[:notice] = "Please enter your login information"
  end

end