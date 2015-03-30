class Api::PostsController < ApplicationController
  before_filter :authenticate!
  rescue_from ActiveRecord::RecordNotFound do
    render status: :not_found, json: {
      error: "Couldn't find post with id #{params[:id]}"
    }
  end

  def index
    render json: Post.all.to_json(only: %i(id title))
  end

  def show
    render json: Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: { success: true }
    else
      render json: { success: false, errors: post.errors }
    end
  end

  def create
    post = Post.new(post_params)
    if post.save
      render json: { success: true }
    else
      render json: { success: false, errors: post.errors }
    end
  end

  private

    def authenticate!
      return if request.headers['X-AUTH-TOKEN'] == 'abcdefg'
      render status: :unauthorized, json: { error: "Not authenticated" }
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
