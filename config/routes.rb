# frozen_string_literal: true

Rails.application.routes.draw do
  resources :akerun_unlock_requests, only: %i[create]
end
