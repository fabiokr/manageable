300.times do
  Sample.create(
    :text_field =>      "text#{rand(1000)}",
    :password_field =>      "text#{rand(1000)}",
    :telephone_field =>      "text#{rand(1000)}",
    :date_field =>      "text#{rand(1000)}",
    :url_field =>      "text#{rand(1000)}",
    :email_field =>      "text#{rand(1000)}",
    :number_field =>      "text#{rand(1000)}",
    :range_field =>      "text#{rand(1000)}",
    :file_field =>      "text#{rand(1000)}",
    :radio_button =>      "text#{rand(1000)}",
    :text_area =>      "text#{rand(1000)}",
    :checkbox_one => true,
    :checkbox_two => true
  )
end