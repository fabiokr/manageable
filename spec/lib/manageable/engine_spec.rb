require 'spec_helper'

describe "The Engine" do

  it "should define the module" do
    Manageable.should be_a(Module)
  end

end