module Manageable
  module ApplicationHelper
    # Create a content box.
    #
    # options - A hash of options to apply to the box.
    # &block - The content of the box, passed an instance of Helpers::BoxBuilder.
    #
    # Valid options:
    #
    # * :headline -- The headline to show in the box.
    # * :class -- A class to apply to the box.
    # * :id -- The ID to apply to the box.
    #
    # Example:
    #   <% content_box :headline => "My Box", :class => "alert", :id => "my_box" do |box| %>
    #     <% box.navigation do |nav| %>
    #       <% nav.item "List People", people_path, :active => true %>
    #       <% nav.item "New Person", new_person_path %>
    #       <% nav.item "Search", search_path(:type => "people") %>
    #     <% end %>
    #
    #     <% box.breadcrumbs do |crumbs| %>
    #       <% crumbs.item "Home", root_path %>
    #       <% crumbs.item "People", people_path %>
    #       <% crumbs.item "Bob Jones", person_path(@person), :active => true %>
    #     <% end %>
    #
    #     <p>This is a really neat box, which will be displayed with a headline and navigation.</p>
    #   <% end %>
    #
    # Returns the completed box, yields an instance of Helpers::BoxBuilder.
    def manageable_content_box(options = {}, &block)
      box_buffer = Helpers::BoxBuilder.new(self)
      box_content = capture(box_buffer, &block)

      options = {
        :id => nil,
        :class => []
      }.merge(options)

      block_class = ([ "block" ] + [ options[:class] ].flatten).join(" ")

      content_tag(:div, :class => block_class, :id => options[:id]) do
        block_out = box_buffer.buffers[:block_header].html_safe
        block_out << content_tag(:div, :class => "content") do
          content_out = ''.html_safe
          content_out = content_tag(:h2, options[:headline]) if options[:headline]
          content_out << content_tag(:div, box_content, :class => 'inner')
        end
        block_out << box_buffer.buffers[:block_footer].html_safe
      end
    end

    # Get or set the page title
    #
    # title - The title to set. (optional)
    #
    # Example:
    #   page_title("Hello, world!")
    #   # => "Hello, world!"
    #   page_title
    #   # => "Hello, world!"
    #
    # Returns the page title, first setting it if title is not nil.
    def manageable_page_title(title = nil)
      @title = title unless title.nil?
      @title || "Untitled Page"
    end

    # Display an icon
    #
    # name - The icon to display
    # size - One of :small or :large (optional)
    # options - A hash to be passed to the image_tag helper (optional)
    #
    # Example:
    #   manageable_icon("add")
    #   # => image_tag("/assets/manageable/icons/16x16/add.png", :alt => "Add")
    #   manageable_icon("new_item", :large)
    #   # => image_tag("/assets/manageable/icons/32x32/new_item.png, :alt => "New Item")
    #
    # Returns an image tag, ready to be displayed in a template.
    def manageable_icon(name, size = :small, options = {})
      return "" if name.nil?

      dimension = ( (size == :small) ? "16" : "32" ).html_safe
      options[:alt] ||= name.capitalize.gsub("_", " ")

      image_tag(asset_path("manageable/icons/#{dimension}x#{dimension}/#{name}.png"), {
        :alt => options[:alt]
      })
    end

    def manageable_navigation(options = {}, &block)
      options[:class] ||= ""
      options[:class].strip!

      options[:ul_class] ||= "wat-cf"
      options[:ul_class].strip!

      menu = Helpers::NavigationBuilder.new
      yield menu if block_given?

      content_tag("div", options) do
        content_tag("ul", "", :class => options[:ul_class]) do
          menu.collect { |item|
            content_tag("li", :class => item[:class]) do
              link_to(item[:label], item[:href], item[:link_options])
            end
          }.join("").html_safe
        end
      end
    end

    # Displays a secondary naviagtion menu
    #
    # options - A hash of attributes to apply to the wrapping div tag
    #
    # Example:
    #   <div class="block">
    #     <%= secondary_navigation do |nav|
    #       nav.item "List People", people_path, :active => true
    #       nav.item "New Person", new_person_path
    #       nav.item "Search", search_path(:type => "people")
    #     end %>
    #     <div class="content">
    #       <h2 class="title">List People</h2>
    #     </div>
    #   </div>
    #
    # Returns a secondary navigation block to be displayed.
    def manageable_secondary_navigation(options = {}, &block)
      options[:class] ||= ""
      options[:class] << " secondary-navigation"

      manageable_navigation(options, &block)
    end

    # Creates a set of buttons
    #
    # options - A hash of attributes to apply to the wrapping div tag
    #
    # Example:
    #   <div class="block">
    #     <div class="content">
    #       <%= controls do |c|
    #         c.item "Copy", copy_person_path(person), :icon => "copy_person"
    #         c.item "Delete", person_path(person), :method => :delete
    #       end %>
    #     </div>
    #   </div>
    #
    # Returns a set of controls to be displayed.
    def manageable_controls(options = {})
      options[:class] ||= ""
      options[:class] << " control"
      options[:class].strip!

      items = Helpers::NavigationBuilder.new
      yield items if block_given?

      content_tag("div", options) do
        items.collect { |item|
          manageable_button(item[:label], item[:href], item[:link_options].merge(:icon => item[:icon]))
        }.join("").html_safe
      end
    end

    # Displays a breadcrumb trail
    #
    # options - A hash of attributes to apply to the wrapping div tag
    #
    # Example:
    #   <div class="block">
    #     <div class="content">
    #       <h2><%= @news_item.title %></h2>
    #       <p><%= @news_item.content %></p>
    #     </div>
    #     <%= breadcrumbs do |b|
    #       b.item "Home", root_path
    #       b.item "News", news_path
    #       b.item "Awesome New Things", news_path(@news_item), :active => true
    #     %>
    #   </div>
    #
    # Returns the breadcrumb trail.
    def manageable_breadcrumbs(options = {})
      items = Helpers::NavigationBuilder.new
      yield items if block_given?

      options[:class] ||= ""
      options[:class] << " breadcrumb"
      options[:class].strip!

      content_tag("div", options) do
        content_tag("ul") do
          items.collect { |item|
            content_tag("li", :class => item[:class]) do
              if item[:active]
                item[:label]
              else
                link_to(item[:label], item[:href])
              end
            end
          }.join("").html_safe
        end
      end
    end

    # Links to a sortable column.
    # *column*: - The column to link to
    # *title*:  - The link title
    # *options*: - Additional link_to options
    def manageable_sortable(column, title = nil, options = {})
      title ||= column.titleize

      if respond_to?(:sort_column) && respond_to?(:sort_direction)
        css_class = column && sort_column && column.to_sym == sort_column.to_sym ? "sort_#{sort_direction}" : nil
        direction = column && sort_column && column.to_sym == sort_column.to_sym && sort_direction == "asc" ? "desc" : "asc"
        options[:class] = [options[:class], css_class].compact.join(" ")

        link_to title, params.merge(:sort => column, :direction => direction, :page => nil), options
      else
        title
      end
    end

    # Creates a link_to button
    def manageable_button(body, url, html_options = {})
      html_options[:class] = [html_options[:class], "button"].compact.join(" ")
      icon = manageable_icon(html_options.delete(:icon), :small, :alt => body) if html_options[:icon]

      link_to url, html_options do
        [icon, body].compact.join("&nbsp;").html_safe
      end
    end

    # Prints a pagination block. Accepts the following options:
    #
    # *current_page*
    # *num_pages*
    # *param_name*
    def manageable_pagination(options = {})
      current_page = options[:current_page] || 1
      num_pages    = options[:num_pages] || 1
      outer_window = options[:outer_window] || 4
      page_param   = options[:param_name] || :page

      if current_page <= num_pages
        previous_page = current_page - 1
        next_page     = current_page + 1
        left_window   = ((current_page - outer_window)...current_page).to_a.select{|i| i > 0}
        right_window  = ((current_page + 1)..(current_page + outer_window)).to_a.select{|i| i <= num_pages}

        elements = []

        if 1 != current_page
          # First
          elements <<  {:value => t("manageable.pagination.first"), :href => params.merge(page_param => 1)}

          # Previous
          elements <<  {:value => t("manageable.pagination.previous"), :href => params.merge(page_param => previous_page)}
        end

        # Left Gap
        if left_window.first && left_window.first != 1
          elements <<  {:value => t("manageable.pagination.gap")}
        end

        # Left window
        left_window.each do |i|
          elements <<  {:value => i, :href => params.merge(page_param => i)}
        end

        # Current Page
        elements <<  {:value => current_page, :html => {:class => "current"}}

        # Right window
        right_window.each do |i|
          elements <<  {:value => i, :href => params.merge(page_param => i)}
        end

        # Right Gap
        if right_window.last && right_window.last != num_pages
          elements <<  {:value => t("manageable.pagination.gap")}
        end

        if num_pages != current_page
          # Next
          elements <<  {:value => t("manageable.pagination.next"), :href => params.merge(page_param => next_page)}

          # Last
          elements <<  {:value => t("manageable.pagination.last"), :href => params.merge(page_param => num_pages)}
        end

        content_tag :div, :class => "pagination" do
          elements.map do |options|
            if options[:href]
              link_to options[:value], options[:href]
            else
              content_tag(:span, options[:value], options[:html])
            end
          end.join.html_safe
        end
      end
    end

    # Helper for custom attrtastic like builder
    def manageable_attributes(record, options = {}, &block)
      options[:html] ||= {}

      html_class = [ "attrtastic", record.class.to_s.underscore, options[:html][:class] ].compact.join(" ")

      output = tag(:div, { :class => html_class}, true)
      if block_given?
        output << capture(Helpers::AttributesBuilder.new(record, self), &block)
      else
        output << capture(Helpers::AttributesBuilder.new(record, self)) do |attr|
          attr.attributes
        end
      end
      output.safe_concat("</div>")
    end

    # Default customizable helpers

    def manageable_head
      content_for(:head)
    end

    def manageable_javascripts
      content_for(:javascripts)
    end

    def manageable_sidebar
      content_for(:sidebar)
    end

    def manageable_logo
      content_tag(:h1, "Manageable")
    end

    def manageable_footer
      content_tag(:p, "Manageable - Activo Theme by David Francisco / hello@dmfranc.com / activo.dmfranc.com")
    end

    def manageable_user_navigation(menu)
      menu.item image_tag("manageable/session/home.png", :alt => "Dashboard", :"original-title" => "Dashboard"), "#"
      menu.item image_tag("manageable/session/account.png", :alt => "Profile", :"original-title" => "Profile"), "#"
      menu.item image_tag("manageable/session/config.png", :alt => "Preferences", :"original-title" => "Preferences"), "#"
      menu.item image_tag("manageable/session/logout.png", :alt => "Logout", :"original-title" => "Logout"), "#"
    end

    def manageable_main_navigation(menu)
       menu.item "Main Page", "#"
       menu.item "Active", "#", :class => "active"
       menu.item "Login", "#"
    end
  end
end
