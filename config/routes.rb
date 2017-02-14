Spree::Core::Engine.routes.draw do

  resources :orders do
    post 'postback', :to => 'orders#postback', :as => :postback
  end

  namespace :admin do
    resources :banks

    resources :users do
      resources :bank_accounts do
        post 'revalidate', :on => :member
        post 'check_pagarme', :on => :member
      end
    end
  end
  
end