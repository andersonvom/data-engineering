Importer::Application.routes.draw do
  resources :imports

  # You can have the root of your site routed with "root"
  root 'imports#index'
end
