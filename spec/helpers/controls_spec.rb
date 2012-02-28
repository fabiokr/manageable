require 'spec_helper'

describe Manageable::ApplicationHelper, "control sets" do
  it "should yield a navigation builder" do
    helper.controls do |c|
      c.should be_instance_of(Manageable::Helpers::NavigationBuilder)
    end
  end
end
