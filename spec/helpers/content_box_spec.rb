require 'spec_helper'

describe Manageable::ApplicationHelper, "content_box" do
  it "should yield a box builder" do
    helper.manageable_content_box(:headline => "My Box") do |b|
      b.should be_instance_of(Manageable::Helpers::BoxBuilder)
    end
  end

  it "should build without a headline" do
    lambda { helper.manageable_content_box { |b| "Hello, world" } }.should_not raise_exception
  end
end

