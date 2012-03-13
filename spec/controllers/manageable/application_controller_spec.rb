require 'spec_helper'

describe Manageable::ApplicationController do
  controller do
    respond_to :html

    def index
      render :text => "index"
    end

    # mock paths
    def paths_custom_collection_path(*args)
      "the_paths_custom_collection(#{args})"
    end

    def paths_custom_resource_path(*args)
      "the_paths_custom_resource(#{args})"
    end

    def new_paths_custom_resource_path(*args)
      "the_new_paths_custom_resource(#{args})"
    end

    def edit_paths_custom_resource_path(*args)
      "the_edit_paths_custom_resource(#{args})"
    end
  end

  describe "#manageable_configuration" do
    before do
      controller.class.manageable_configuration FakeModel,
        :vars => { :resource => :custom_resource, :collection => :custom_collection },
        :paths => {
          :collection    => :paths_custom_collection,
          :resource      => :paths_custom_resource,
          :new_resource  => :new_paths_custom_resource,
          :edit_resource => :edit_paths_custom_resource
        }
    end

    it "should set resource_class" do
      controller.class.resource_class.should == FakeModel
    end

    it "should set resource_vars" do
      controller.class.resource_vars.should == { :resource => :custom_resource, :collection => :custom_collection }
    end

    it "should set resource_paths" do
      controller.class.resource_paths.should == {
          :collection    => :paths_custom_collection,
          :resource      => :paths_custom_resource,
          :new_resource  => :new_paths_custom_resource,
          :edit_resource => :edit_paths_custom_resource
        }
    end

    describe "istance accessors" do
      let(:expected) { FakeModel.new }

      before do
        controller.should_receive(:respond_with_without_storage).and_return(nil)
        controller.respond_with([FakeModel.new, FakeModel.new, expected])
      end

      it "should retrieve the last resource with #resource" do
        controller.send(:resource).should == expected
      end

      it "should retrieve the last resource with #collection" do
        controller.send(:collection).should == expected
      end
    end

    describe "url_helpers" do
      it "should retrieve #collection_path" do
        controller.send(:collection_path, 1, 2).should == "the_paths_custom_collection([1, 2])"
      end

      it "should retrieve #resource_path" do
        controller.send(:resource_path, 1, 2).should == "the_paths_custom_resource([1, 2])"
      end

      it "should retrieve #new_resource_path" do
        controller.send(:new_resource_path, 1, 2).should == "the_new_paths_custom_resource([1, 2])"
      end

      it "should retrieve #edit_collection_path" do
        controller.send(:edit_resource_path, 1, 2).should == "the_edit_paths_custom_resource([1, 2])"
      end
    end
  end

end