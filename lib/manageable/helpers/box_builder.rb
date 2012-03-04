# Provides a container for boxes that are currently being constructed.
module Manageable
  module Helpers
    class BoxBuilder
      # :nodoc:
      attr_reader :buffers

      # :nodoc:
      def initialize(parent)
        @parent = parent
        @buffers = { :block_header => '', :block_footer => '' }
      end

      # Sets the controls to display in this box. See Activo::Rails::Helper#controls.
      def controls(options = {}, &block)
        buffers[:block_header] << @parent.manageable_controls(options, &block)
        ''
      end

      # Sets the navigation to display on this box. See Activo::Rails::Helper#navigation.
      def navigation(options = {}, &block)
        buffers[:block_header] << @parent.manageable_secondary_navigation(options, &block)
        ''
      end

      # Sets the breadcrumbs to display in this box. See Activo::Rails::Helper#breadcrumbs.
      def breadcrumbs(options = {}, &block)
        buffers[:block_footer] << @parent.manageable_breadcrumbs(options, &block)
        ''
      end
    end
  end
end