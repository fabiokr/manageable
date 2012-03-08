module Manageable
  module Helpers
    class AttributesBuilder < Attrtastic::SemanticAttributesBuilder
      def left_attribute(attr, options = {}, &block)
        options[:html] ||= {}
        options[:html][:class] = ["column_left", options[:html][:class]].compact.join(" ")
        attribute(attr, options, &block)
      end

      def right_attribute(attr, options = {}, &block)
        options[:html] ||= {}
        options[:html][:class] = ["column_right", options[:html][:class]].compact.join(" ")
        attribute(attr, options, &block)
      end
    end
  end
end