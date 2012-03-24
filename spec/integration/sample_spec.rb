require 'spec_helper'

describe SamplesController do

  it "should work with all rest actions" do
    visit "/samples"
    click_link "New"
    click_button "Save"
    click_link "Edit"
    click_button "Save"
    click_link "Delete"
  end

end
