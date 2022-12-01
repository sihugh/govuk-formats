Rails.application.routes.draw do
  root to: "homepage#index"

  get "/document-types", to: "document_type#index"
  get "/document-types/:document_type", to: "document_type#show"

  get "/organisations", to: "organisations#index"
  get "/organisations/:slug", to: "organisations#show"

  get "/taxons", to: "taxons#index"

  get "/finders", to: redirect("/document-types/finder")
  get "/step-by-steps", to: redirect("/document-types/step-by-step-nav")
end
