# Assists in the creation of navigation menus
module Manageable
  module Helpers
    class NavigationBuilder
      attr_reader :item_list
      include Enumerable

      def initialize
        @item_list = []
      end

      def each(&blk)
        item_list.each(&blk)
      end

      def item(label, path, options = {})
        options[:class] ||= ""
        options[:class] << " first" if item_list.empty?
        options[:class] << " active" if options[:active]

        options[:link_options] ||= {}
        options[:link_options].merge!(:method => options[:method]) if options[:method]

        item_list << {
          :label => label,
          :href => path,
          :class => options[:class].strip,
          :link_options => options[:link_options],
          :icon => options[:icon],
          :active => !!options[:active]
        }
      end
    end
  end
end