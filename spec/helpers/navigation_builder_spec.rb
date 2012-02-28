require 'spec_helper'

describe Manageable::ApplicationHelper, "navigation" do
  it "should yield a navigation builder" do
    helper.manageable_navigation do |b|
      b.should be_instance_of(Manageable::Helpers::NavigationBuilder)
    end
  end
end
