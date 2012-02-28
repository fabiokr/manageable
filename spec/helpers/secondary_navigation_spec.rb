require 'spec_helper'

describe Manageable::ApplicationHelper, "secondary navigation menus" do
  it "yields an instance of NavigationBuilder" do
    helper.manageable_secondary_navigation do |nav|
      nav.should be_instance_of(Manageable::Helpers::NavigationBuilder)
    end
  end
end
