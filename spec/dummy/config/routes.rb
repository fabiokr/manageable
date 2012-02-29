Dummy::Application.routes.draw do
  match "/session" => "sessions#index"
  root :to => "manageable#index"
end