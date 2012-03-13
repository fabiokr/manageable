require 'spec_helper'

describe SamplesController, :js => true do

  it "should work with all rest actions" do
    visit "/samples"
    puts page.body
    click_link "New Sample"
    click_button "Save"
    click_link "Edit"
    click_button "Save"
    click_link "Delete"
  end

end