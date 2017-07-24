Spree::Core::Engine.add_routes do
  # Add your extension routes here
  resources :orders do
    resource :checkout, :controller => 'checkout' do
      member do
        get :skrill_cancel
      end
    end
  end

end
