module Manageable
  class ApplicationController < ActionController::Base
    class << self
      # paths
      #  :collection => :examples
      #  :resource => :example
      #  :new_resource => :new_example
      #  :edit_resource => :edit_example
      def manageable_configuration(klass, paths = {})
        resource_class klass
        resource_paths paths
      end

      def resource_class(klass = nil)
        @resource_class = klass if klass
        @resource_class
      end

      def resource_paths(paths = nil)
        @resource_paths = paths if paths
        @resource_paths
      end
    end

    layout 'manageable/application'

    helper_method :resource_class, :resource, :collection,
                  :collection_path, :resource_path, :new_resource_path, :edit_resource_path

    # Custom respond_with wich stores resources for later use
    def respond_with(*resources, &block)
      @responded_with = resources
      super(*resources, &block)
    end

    protected

    def resource_class
      if klass = self.class.resource_class
        klass
      else
        raise NotImplementedError, "You have to define the resource_class method in your controller"
      end
    end

    def resource
      @responded_with.last
    end
    alias_method :collection, :resource

    def collection_path(*args)
      find_resource_path(:collection, *args)
    end

    def resource_path(*args)
      find_resource_path(:resource, *args)
    end

    def new_resource_path(*args)
      find_resource_path(:new_resource, *args)
    end

    def edit_resource_path(*args)
      find_resource_path(:edit_resource, *args)
    end

    private

    def find_resource_path(path, *args)
      if path = self.class.resource_paths[path]
        send "#{path}_path", *args
      else
        raise NotImplementedError, "You have to define the #{path}_path method in your controller or configure it with manageable_configuration"
      end
    end

  end
end