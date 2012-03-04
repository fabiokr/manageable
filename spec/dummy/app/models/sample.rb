class Sample < ActiveRecord::Base
  validates :text_field, :presence => true
  validates :password_field, :presence => true
  validates :telephone_field, :presence => true
  validates :date_field, :presence => true
  validates :url_field, :presence => true
  validates :email_field, :presence => true
  validates :number_field, :presence => true
  validates :range_field, :presence => true
  validates :file_field, :presence => true
  validates :radio_button, :presence => true
  validates :text_area, :presence => true
  validates :checkbox_one, :presence => true
  validates :checkbox_two, :presence => true
end
