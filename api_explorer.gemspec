$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api_explorer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api_explorer"
  s.version     = ApiExplorer::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ApiExplorer."
  s.description = "TODO: Description of ApiExplorer."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency 'jquery-rails'
  s.add_dependency 'httparty'

  s.add_development_dependency "sqlite3"
end
