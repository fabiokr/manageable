require 'spec_helper'

describe Manageable::ApplicationHelper, "breadcrumbs" do
  it "should yield a navigation builder" do
    helper.breadcrumbs do |b|
      b.should be_instance_of(Manageable::Helpers::NavigationBuilder)
    end
  end
end
