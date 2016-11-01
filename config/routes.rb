Spree::Core::Engine.routes.draw do

	resources :orders do
      post 'postback', :to => 'orders#postback', :as => :postback
    end
end