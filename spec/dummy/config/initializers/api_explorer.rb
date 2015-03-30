ApiExplorer.describe do
  base_url case Rails.env
           when 'development'
             'http://localhost:3000/api/'
           when 'production'
             'http://rails-api-explorer.herokuapp.com/api/'
           end

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
