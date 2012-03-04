module Manageable
  module Helpers

    # This custom FormBuilder automatically adds labels to form fields.
    class FormBuilder < ::ActionView::Helpers::FormBuilder

      @@field_with_errors_proc = Proc.new do |method, label_tag, object, template|
        if object.respond_to?(:errors) && object.errors.respond_to?(:[]) && object.errors[method].present?
          template.content_tag(:div, :class => "fieldWithErrors") do
            label_tag + "&nbsp".html_safe + template.content_tag(:span, object.errors[method].first, :class => "error")
          end
        else
          label_tag
        end
      end

      # Generates an activo compliant submit button
      def button(value=nil, options={})
        value, options = nil, value if value.is_a?(Hash)

        value         ||= I18n.t("manageable.save")
        options[:class] = [options[:class], "button"].compact.join(" ")
        image           = @template.image_tag(options.delete(:image) || "/assets/manageable/icons/tick.png", :alt => value)

        @template.button_tag(options) do
          [image, value].compact.join("&nbsp;").html_safe
        end
      end

      def text_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def password_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def telephone_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def url_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def email_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def number_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def range_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def file_field(method, options={})
        options[:class] = [options[:class], "text_field"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def text_area(method, options={})
        options[:class] = [options[:class], "text_area"].compact.join(" ")
        labeled_field(method, super(method, options), options)
      end

      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        options[:class] = [options[:class], "checkbox"].compact.join(" ")
        label_tag = label(method, :class => "checkbox")
        label_tag = @@field_with_errors_proc.call(method, label_tag, @object, @template)

        @template.content_tag(:div) do
          (super(method, options, checked_value, unchecked_value) + label_tag).html_safe
        end
      end

      def radio_button(method, tag_value, options = {})
        options[:class] = [options[:class], "radio"].compact.join(" ")
        label_tag = label(method, :class => "radio")
        label_tag = @@field_with_errors_proc.call(method, label_tag, @object, @template)

        @template.content_tag(:div) do
          (super(method, tag_value, options) + label_tag).html_safe
        end
      end

      def labeled_field(method, field_tag, options = {})
        label_tag = label(method, :class => "label")
        description_tag = @template.content_tag(:span, options.delete(:description), :class => "description") if options[:description].present?

        # Applies fieldWithErrors
        label_tag = @@field_with_errors_proc.call(method, label_tag, @object, @template)

        @template.content_tag :div, :class => "group" do
          (label_tag + field_tag + description_tag).html_safe
        end
      end
    end
  end
end