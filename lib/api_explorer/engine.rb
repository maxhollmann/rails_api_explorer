module ApiExplorer
  class Engine < ::Rails::Engine
    isolate_namespace ApiExplorer

    initializer "rails_api_explorer.assets.precompile" do |app|
      app.config.assets.precompile += %w(api_explorer.css api_explorer.js)
    end
  end
end
