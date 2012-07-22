Chefpad::Application.routes.draw do
  post '/api/session' => 'api#create_session', :as => 'api_session'
  
  get '/api/:token/account' => 'api#account', :as => 'api_account'
  get '/api/:token/recipes' => 'api#index_recipes', :as => 'api_recipe'
  post '/api/:token/recipes' => 'api#create_recipe'
end

