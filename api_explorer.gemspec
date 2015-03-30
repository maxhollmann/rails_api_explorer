$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api_explorer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_api_explorer"
  s.version     = ApiExplorer::VERSION
  s.authors     = ["Max Hollmann"]
  s.email       = ["maxhollmann@gmail.com"]
  s.homepage    = "https://github.com/maxhollmann/rails_api_explorer"
  s.summary     = "Provides a simple DSL to describe your JSON API, and let's you mount an interactive sandbox to explore and test it."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md",
  ]
  s.files -= Dir[
    "app/assets/**/*.coffee",
    "app/assets/**/*.scss",
  ]

  s.add_dependency "rails"#, "~> 3.1.0"
  s.add_dependency 'jquery-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "coffee-script"
  s.add_development_dependency "sass"
end
