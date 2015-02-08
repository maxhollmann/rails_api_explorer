class Api::SessionController < ApplicationController
  def create
    if login_params[:email].present? && login_params[:password].present?
      render json: { success: true, auth_token: "abcdefg" }
    else
      render json: { success: false, error: "Wrong email or password" }
    end
  end

  private

    def login_params
      params[:user_login] || {}
    end
end
