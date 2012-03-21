require "active_support"

module Manageable
  module Helpers
    class AttributesBuilder
      # Only for testing purposes
      attr_reader :record, :template

      # For compatibility with formtastic
      alias :object :record

      def initialize(record, template)
        @record, @template = record, template
      end

      def attributes(*args, &block)
        options = args.extract_options!
        options[:html] ||= {}

        if args.first and args.first.is_a? String
          options[:name] = args.shift
        end

        if options[:for].blank?
          attributes_for(record, args, options, &block)
        else
          for_value = if options[:for].is_a? Symbol
            record.send(options[:for])
          else
            options[:for]
          end

          [*for_value].map do |value|
            value_options = options.clone
            value_options[:html][:class] = [ options[:html][:class], value.class.to_s.underscore ].compact.join(" ")

            attributes_for(value, args, options, &block)
          end.join.html_safe
        end
      end

      def attribute(*args, &block)
        options = args.extract_options!
        options[:html] ||= {}

        method = args.shift

        html_label_class = [ "label", options[:html][:label_class] ].compact.join(" ")
        html_value_class = [ "value", options[:html][:value_class] ].compact.join(" ")

        html_class = [ "attribute", options[:html][:class] ]

        position = options.delete(:position)
        html_class << "column_left"  if position == :left
        html_class << "column_right" if position == :right
        html_class = html_class.compact.join(" ")

        label = options.key?(:label) ? options[:label] : label_for_attribute(method)

        unless block_given?
          value = if options.key?(:value)
            case options[:value]
              when Symbol
                attribute_value = value_of_attribute(method)
                case attribute_value
                  when Hash
                    attribute_value[options[:value]]
                  else
                    attribute_value.send(options[:value])
                end
              else
                options[:value]
            end
          else
            value_of_attribute(method)
          end

          value = case options[:format]
            when false
              value
            when nil
              format_attribute_value(value)
            else
              template.send(options[:format], value)
          end

          if value.present? or options[:display_empty]
            output = template.tag(:li, {:class => html_class}, true)
            output << template.content_tag(:span, label, :class => html_label_class)
            output << template.content_tag(:span, value, :class => html_value_class)
            output.safe_concat("</li>")
          end
        else
          output = template.tag(:li, {:class => html_class}, true)
          output << template.content_tag(:span, label, :class => html_label_class)
          output << template.tag(:span, {:class => html_value_class}, true)
          output << template.capture(&block)
          output.safe_concat("</span>")
          output.safe_concat("</li>")
        end
      end

      private

      def attributes_for(object, methods, options, &block)
        new_builder = self.class.new(object, template)

        html_class = [ "attributes", options[:html].delete(:class) ].compact.join(" ")
        html_header_class = [ "legend", options[:html].delete(:header_class) ].compact.join(" ")

        output = template.tag(:div, {:class => html_class}, true)

        header = options[:name]

        if header.present?
          output << template.content_tag(:div, :class => html_header_class) do
            template.content_tag(:span, header)
          end
        end

        if block_given?
          output << template.tag(:ol, {}, true)
          output << template.capture(new_builder, &block)
          output.safe_concat("</ol>")
        else
          if methods.blank? && object.respond_to?(:attribute_names)
            methods = object.attribute_names
          end
          output << template.tag(:ol, {}, true)
          methods.each do |method|
            output << new_builder.attribute(method, options)
          end
          output.safe_concat("</ol>")
        end

        output.safe_concat("</div>")
      end

      def label_for_attribute(method)
        if record.class.respond_to?(:human_attribute_name)
          record.class.human_attribute_name(method.to_s)
        else
          method.to_s.send(:humanize)
        end
      end

      def value_of_attribute(method)
        record.send(method)
      end

      def format_attribute_value(value)
        case value
          when Date, Time, DateTime
            template.send(:l, value)
          when Integer
            template.send(:number_with_delimiter, value)
          when Float, BigDecimal
            template.send(:number_with_precision, value)
          else
            value.to_s
        end
      end
    end
  end
end