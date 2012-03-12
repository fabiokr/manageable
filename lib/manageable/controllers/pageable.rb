module Manageable
  module Controllers

    # This module provides sorting functionality for resource controllers.
    module Pageable
      extend ActiveSupport::Concern

      included do
        helper_method :sort_column, :sort_direction
      end

      protected

      # Calls "order" and "page" scope in the resource.
      # A valid order by parameter will be passed in to "order", and params[:page] to
      # the "page" scope.
      #
      # Example parameters that will be passed for sorted:
      #
      #   created_at ASC
      #   created_at DESC
      #
      # *scope* - a valid active_record relation
      def apply_pageable_scope(scope)
        scope = scope.order(generate_order_by)
        scope = scope.page(params[:page])
      end

      # Mounts an order by parameter based on the current params.
      def generate_order_by
        if sort_column && sort_direction
          "#{sort_column} #{sort_direction}"
        elsif sort_column
          sort_column
        else
          "created_at DESC"
        end
      end

      # Extracts the order by column from params[:sort]
      def sort_column
        params[:sort]
      end

      # Extracts the order by direction from params[:direction]
      def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : nil
      end
    end
  end
end