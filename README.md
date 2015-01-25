# rails_api_explorer

Provides a simple DSL to describe your API, and let's you mount an interactive sandbox to explore and test it.

This project is in the very early stages of development, and I mainly extend it to scratch my own itches.
Pull requests are more than welcome!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_api_explorer', github: 'maxhollmann/rails_api_explorer'
```

And then execute:

    $ bundle

## Usage

Describe your API in `config/initializers/api_explorer.rb`:

```ruby
ApiExplorer.base_url = case Rails.env
                       when 'development'
                         'http://localhost:3000/api/'
                       when 'production'
                         'http://example.com/api/'
                       end

ApiExplorer.describe do
  shared do
    header 'X-AUTH-TOKEN', source: { request: "POST:users/sign_in", accessor: "['auth_token']"}
    # The source option makes the value get set automatically when a request to the given url succeeds.
    # The accessor is evaluated on the JSON object returned by the server.
  end

  post 'users/sign_in' do
    desc "Describe this action."

    exclude_shared_header 'X-AUTH-TOKEN'

    struct 'user_login' do
      string 'email'
      string 'password'
    end
  end

  get 'posts' do
    integer 'page', desc: "Optional."
  end

  patch 'posts/:id' do
    struct 'post' do
      string 'title'
      string 'body'
    end
  end
end
```

Then mount it in your `routes.rb`:

```ruby
mount ApiExplorer::Engine => '/api/explore', as: 'api_explorer'
```


If you don't want the public to access the explorer, you can provide a lambda that will be executed in the `before_filter` of the controller:

```ruby
ApiExplorer.auth = lambda do
  authenticate_user!
  current_user.admin? or redirect_to main_app.root_path
end
```

The explorer is rendered within your application layout and uses bootstrap 3 classes, so it's prettier if you have that included.
Bootstrap is optional, but it requires jQuery.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
