Spree::Core::Engine.routes.draw do

  resources :orders do
    post 'postback', :to => 'orders#postback', :as => :postback
  end

  namespace :admin do
    resources :banks

    resources :users do
      resources :bank_accounts
    end
  end
  
end