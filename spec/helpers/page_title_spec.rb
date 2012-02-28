require 'spec_helper'

describe Manageable::ApplicationHelper, "setting the page title" do
  it "sets the title attribute when #page_title is called with an argument" do
    helper.manageable_page_title "Example"
    helper.instance_variable_get("@title").should eq("Example")
  end

  it "returns the title when #page_title is called with no arguments" do
    helper.manageable_page_title "A Title"
    helper.manageable_page_title.should eq("A Title")
  end

  it "returns 'Untitled Page' if no other value has been set" do
    helper.manageable_page_title.should eq("Untitled Page")
  end
end
