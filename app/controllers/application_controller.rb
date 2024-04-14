class ApplicationController < ActionController::API
  before_action :enforce_api_key

  private

  def enforce_api_key
    header = request.headers["Authorization"]

    if header.nil? || header.empty?
      render json: "Incorrect header parameters", status: 401
      return
    end

    type = header.split[0]
    key = header.split[1]

    if type != "Bearer" || key != ENV['API_KEY']
      render json: "Incorrect header parameters", status: 401
      return
    end
  end
end
