require 'spec_helper'

describe Manageable::ApplicationHelper, "displaying icons" do
  it "returns an empty string when called with nil" do
    helper.icon(nil).should eq("")
  end

  it "creates an image tag containing the appropriate icon when called" do
    helper.should_receive(:image_tag).with("/assets/manageable/icons/16x16/add.png", instance_of(Hash))
    helper.icon("add")
  end

  it "creates the icon at 16x16 when size is small" do
    helper.should_receive(:image_tag).with("/assets/manageable/icons/16x16/add.png", instance_of(Hash))
    helper.icon("add", :small)
  end

  it "creates the icon at 32x32 when size is small" do
    helper.should_receive(:image_tag).with("/assets/manageable/icons/32x32/add.png", instance_of(Hash))
    helper.icon("add", :large)
  end

  it "sets the alt attribute to the icon name by default" do
    helper.should_receive(:image_tag).with(duck_type(:to_s), {
      :alt => "Add"
    })
    helper.icon("add", :small)
  end

  it "sets the alt attribute to the provided value if provided" do
    helper.should_receive(:image_tag).with(duck_type(:to_s), {
      :alt => "An icon"
    })
    helper.icon("add", :small, :alt => "An icon")
  end
end
