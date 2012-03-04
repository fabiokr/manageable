class SamplesController < Manageable::ApplicationController
  include Manageable::Controllers::Pageable

  inherit_resources
  respond_to :html

  protected

  # Overrides default to add pagination and sorting
  def end_of_association_chain
    apply_pageable_scope(super)
  end
end