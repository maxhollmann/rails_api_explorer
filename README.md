# rails_api_explorer

Provides a simple DSL to describe your JSON API, and let's you mount an interactive sandbox to explore and test it.

[Here's a demo.](http://rails-api-explorer.herokuapp.com)

[![Gem Version](https://badge.fury.io/rb/rails_api_explorer.svg)](https://badge.fury.io/rb/rails_api_explorer)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_api_explorer'
```

And then execute:

    $ bundle


## Usage

### Describe your API
Describe your API in `config/initializers/api_explorer.rb`:

```ruby
ApiExplorer.describe do
  base_url 'http://localhost:3000/api/'

  shared do
    header 'X-AUTH-TOKEN', source: { request: "POST:users/sign_in", accessor: "['auth_token']"}
    # The source option makes the value get set automatically when a request to the given url succeeds.
    # The accessor is evaluated on the JSON object returned by the server.
  end

  post 'users/sign_in' do
    desc "Authenticate a user, returns the auth token. Anything except blank values will work for this example."

    exclude_shared_header 'X-AUTH-TOKEN'

    struct 'user_login' do
      string 'email'
      string 'password'
    end
  end

  group "Posts" do
    get 'posts'

    get 'posts/:id' do
      desc "Returns details for a single post."
    end

    post 'posts' do
      desc "Create a post."
      struct 'post' do
        string 'title', desc: "Required."
        string 'body'
      end
    end

    patch 'posts/:id' do
      struct 'post' do
        string 'title', desc: "Required."
        string 'body'
      end
    end
  end
end
```

Then mount it in your `routes.rb`:

```ruby
mount ApiExplorer::Engine => '/api/explore', as: 'api_explorer'
```

### Access control
If you don't want the public to access the explorer, you can provide a lambda that will be executed in the `before_filter` of the controller:

```ruby
ApiExplorer.auth = lambda do
  authenticate_user!
  current_user.admin? or redirect_to main_app.root_path
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
