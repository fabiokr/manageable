class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :text_field
      t.string :password_field
      t.string :telephone_field
      t.string :date_field
      t.string :url_field
      t.string :email_field
      t.string :number_field
      t.string :range_field
      t.string :file_field
      t.string :radio_button
      t.string :select_field
      t.string :multiple_select_field
      t.text :text_area
      t.boolean :checkbox_one
      t.boolean :checkbox_two

      t.timestamps
    end
  end
end
