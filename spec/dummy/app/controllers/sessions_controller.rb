class SessionsController < Manageable::SessionsController

  def index
    flash[:notice] = "Please enter your login information"
  end

end