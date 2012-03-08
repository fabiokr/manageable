# require 'spec_helper'

# class ExampleApplicationController
#   class << self
#     def layout(layout = nil)
#       @layout = layout if layout
#       @layout
#     end

#     def helper_method(*args)
#       @helpers ||= []
#       @helpers += args
#     end

#     def append_view_path(*args)
#       @view_paths ||= []
#       @view_paths += args
#     end
#   end

#   include Manageable::Controllers::Application
# end

# describe Manageable::Controllers::Application do

#   it "should set the layout" do
#     ExampleApplicationController.layout.should == "manageable/application"
#   end

#   describe "manageable view resolver" do
#     subject { ExampleApplicationController.append_view_path.last }
#     it { should be_a(ActionView::FileSystemResolver) }
#   end
# end