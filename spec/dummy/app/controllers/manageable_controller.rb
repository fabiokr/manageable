class ManageableController < Manageable::ApplicationController

  def index
    flash[:warning] = "This is a warning"
    flash[:notice]  = "This is a notice"
    flash[:error]   = "This is an error"
  end

end