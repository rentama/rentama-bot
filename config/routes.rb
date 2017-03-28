Rails.application.routes.draw do
  post '/callback' => 'webhook#callback'
  get '/hoge' => 'hoge#index'
end
