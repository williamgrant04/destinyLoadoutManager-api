class StatesController < ApplicationController
  require 'base64'
  def generate_url
    state = SecureRandom.uuid
    State.create!(state_uid: state)
    url = "https://www.bungie.net/en/oauth/authorize?client_id=46609&response_type=code&state=#{state}"
    render json: url, status: 200
  end

  def check_state
    # Post request
    if params[:state].nil?
      render json: "No state given", status: 401
      return
    end

    state = State.find_by(state_uid: params[:state])

    render json: "Incorrect state given", status: 401 if state.nil?

    render json: "Check passed", status: 200 unless state.nil?

    state.destroy!
  end

  def get_tokens
    auth_header = Base64.encode64("46609:#{ENV['CLIENT_SECRET']}")
    response = HTTParty.post("https://www.bungie.net/platform/app/oauth/token/?grant_type=authorization_code&code=#{params[:code]}", {
      headers: {
        "Authorization" => "Basic #{auth_header}",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
    })

    render json: response, status: 200
  end

  def test_endpoint
    render json: "yeah", status: 200
  end
end
