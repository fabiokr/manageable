Dummy::Application.routes.draw do
  match "/session" => "sessions#index"
  resources :samples
  root :to => "home#index"
end