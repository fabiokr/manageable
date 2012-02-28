require 'spec_helper'

describe Manageable::Helpers::NavigationBuilder do
  subject { Manageable::Helpers::NavigationBuilder.new }

  it { should respond_to(:item) }

  describe "adding items to the menu" do
    it "appends the item to the item list" do
      subject.item("New Item", "")
      subject.item("Item 2", "")

      subject.item_list.collect { |item| item[:label] }.should eq([
        "New Item",
        "Item 2"
      ])
    end

    it "sets the path to the one provided" do
      subject.item("New Item", "/new")
      subject.item_list.first[:href].should eq("/new")
    end

    it "sets the first class on the first item to be added" do
      subject.item("New Item", "")
      subject.item("Item 2", "")

      subject.item_list[0][:class].should match(/first/)
      subject.item_list[1][:class].should_not match(/first/)
    end

    it "sets the active class on an item with the active option set" do
      subject.item("New Item", "")
      subject.item("New Item", "", :active => true)

      subject.item_list[0][:class].should_not match(/active/)
      subject.item_list[1][:class].should match(/active/)
    end

    it "defaults link_options to an empty hash" do
      subject.item("New Item", "")
      subject.item_list[0][:link_options].should eq({})
    end

    it "sets the method on link_options if provided" do
      subject.item("New Item", "", :method => :delete)
      subject.item_list[0][:link_options].should eq({ :method => :delete })
    end

    it "sets the method on link_options as it was provided (preserves it)" do
      subject.item("Delete", "", :link_options => {:method => :delete})
      subject.item_list[0][:link_options].should eq({ :method => :delete })
    end

    it "sets the method on link_options as provided through link_options and method optiosn, giving priority to the method option" do
      subject.item("Should Post", "", :link_options => {:method => :delete}, :method => :post)
      subject.item_list[0][:link_options].should eq({ :method => :post })
    end

    it "sets the method on link_options if provided as " do
      subject.item("New Item", "", :method => :delete)
      subject.item_list[0][:link_options].should eq({ :method => :delete })
    end

    it "sets the icon if provided" do
      subject.item("New Item", "", :icon => "new")
      subject.item_list[0][:icon].should eq("new")
    end

    it "does not include an icon if not provided" do
      subject.item("Delete", "")
      subject.item_list[0][:icon].should be_nil
    end

    it "sets the active option to true if provided" do
      subject.item("Delete", "", :active => true)
      subject.item_list[0][:active].should be_true
    end

    it "sets the active option to false if provided" do
      subject.item("Delete", "", :active => false)
      subject.item_list[0][:active].should be_false
    end

    it "sets the active option to false if left empty" do
      subject.item("Delete", "")
      subject.item_list[0][:active].should be_false
    end

  end

  it { should respond_to(:item_list) }
  describe "the item list" do
    it "defaults to an empty array" do
      subject.item_list.should eq([])
    end
  end

  describe "iteration" do
    it { should respond_to(:each) }
    it { should respond_to(:collect) }
  end
end
