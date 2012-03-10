class FakeModel < Struct.new(:name, :id)
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def errors
    { :name => ["is required"] }
  end

  def persisted?
    false
  end
end