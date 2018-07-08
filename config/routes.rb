Spree::Core::Engine.routes.draw do
  namespace :api do
    namespace :ams do
      match '*path' => 'cors#preflight_check', via: [:options]

      resources :products
      resources :line_items
      resources :orders do
        collection do
          get :mine
          get :current
        end
        put :empty, on: :member
      end
      resources :taxonomies
      resources :taxons
      resources :countries, :only => [:index, :show]

      # Order Routes Concern?
      resources :checkouts, only: [:update] do
        member do
          put :next
          put :back_to_state
        end
      end

      resources :users do
        collection do
          post 'token'
        end
      end

    end
  end
end
