module Manageable
  class ApplicationController < ActionController::Base
    class << self
      #  :vars => {
      #    :collection => :examples,
      #    :resource => :example
      #  },
      #  :paths => {
      #    :collection => :examples,
      #    :resource => :example,
      #    :new => :new_example,
      #    :edit => :edit_example,
      # }
      def manageable_configuration(klass, options = {})
        resource_class klass
        resource_vars  options[:vars]
        resource_paths options[:paths]
      end

      # The resource class
      def resource_class(klass = nil)
        @resource_class = klass if klass
        @resource_class
      end

      # The controller var names for the resource
      # E.g.: :collection => :pages, :resource => :page
      def resource_vars(vars = nil)
        @resource_vars = vars if vars
        @resource_vars ||= begin
          {
            :resource   => resource_class.model_name.element,
            :collection => resource_class.model_name.element.pluralize
          }
        end
      end

      def resource_paths(paths = nil)
        @resource_paths = paths if paths
        @resource_paths ||= {}
      end
    end

    layout 'manageable/application'

    helper_method :resource_class, :resource, :collection,
                  :collection_path, :resource_path, :new_resource_path, :edit_resource_path

    # Custom respond_with wich stores resources for later use
    def respond_with_with_storage(*args, &block)
      @responded_with = args.last.is_a?(Hash) ? args - [args.last] : args
      respond_with_without_storage(*args, &block)
    end
    alias_method :respond_with_without_storage, :respond_with
    alias_method :respond_with, :respond_with_with_storage

    protected

    def resource_class
      self.class.resource_class
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
      if self.class.resource_paths[path]
        send "#{self.class.resource_paths[path]}_path", *args
      else
        raise NotImplementedError, "You have to define the #{path}_path method in your controller or configure it with manageable_configuration"
      end
    end

  end
end