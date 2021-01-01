require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  root 'promotion_definitions#index'
  resources :users
  get 'invitation/form' => 'users#invitation'
  post 'invitation/link' => 'users#create_invitation'
  resources :home, only: %i[index]
  resources :organizations, only: %i[index]
  post 'sessions/signin' => 'session#signin'
  delete 'sessions/signout' => 'session#signout'
  post 'promotions/evaluation' => 'client_promotions#evaluation'
  get 'promotions/:code/report' => 'client_promotions#report'
  post 'promotions/generate_token' => 'client_promotions#generate_token', as: :generate_token
  get 'promotions/new_token' => 'client_promotions#new_token', as: :new_token
  get 'promotion_definitions/:id/report' => 'promotion_definitions#report', as: :promotion_definition_report
  get 'promotion_definitions/:id/demographic_report' => 'promotion_definitions#demographic_report', as: :promotion_definition_demographic_report
  get 'promotion_definitions/:id/demographic_report_view' => 'promotion_definitions#demographic_report_view', as: :promotion_definition_demographic_report_view
  resources :promotion_definitions do
    resources :promotions, only: %i[new create index]
  end
  mount Sidekiq::Web => '/sidekiq'
end
