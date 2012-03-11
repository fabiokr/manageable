class SamplesController < ApplicationController
  include Manageable::Controllers::Pageable

  respond_to :html

  manageable_configuration Sample, :paths => {
                                     :collection    => :samples,
                                     :resource      => :sample,
                                     :new_resource  => :new_sample,
                                     :edit_resource => :edit_sample
                                   }

  def index
    respond_with @samples = scoped
  end

  def show
    respond_with @sample = scoped.find(params[:id])
  end

  def new
    respond_with @sample = Sample.new
  end

  def create
    respond_with @sample = Sample.create(params[:sample])
  end

  def edit
    respond_with @sample = scoped.find(params[:id])
  end

  def update
    @sample = scoped.find(params[:id])
    @sample.update_attributes(params[:sample])
    respond_with @sample
  end

  def destroy
    @sample = scoped.find(params[:id])
    @sample.destroy
    respond_with @sample
  end

  protected

  def scoped
    apply_pageable_scope(Sample)
  end
end