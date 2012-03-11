Rails.application.routes.draw do
  if Rails.env.development?
    namespace :manageable do
      match "styleguides" => "styleguides#index"
    end
  end
end