# frozen_string_literal: true

module EasyManageClient
  # Core
  class Core
    attr_accessor :connection, :profile, :response, :success
    def initialize(profile: :default)
      self.profile = profile
      # Firstly, create a connection object.
      self.connection = Faraday.new(
        url: ::EasyManageClient.configuration(profile).root_url,
        headers: headers, params: params
      )
    end

    # Call the api and process the response.
    def perform
      resp = connection.get(request_uri)
      handle_response(resp)
      # If server returns 200, everything is OK.
      self.success = resp.status == 200
    rescue Faraday::Error => e
      self.response = { message: e.message }
      self.success = false
    rescue JSON::ParserError, ::EasyManageClient::InvalidResponseContent
      # Response cannot be handled.
      self.response = { message: 'Invalid response from the server.' }
      self.success = false
    end

    # Response is parsed and checked here.
    def handle_response(resp)
      self.response = JSON.parse(resp.body, symbolize_names: true)

      # :content and :reference must be included in response.
      if response.keys.include?(:content) && response.keys.include?(:reference)
        return
      end

      # :content or :reference not included.
      raise ::EasyManageClient::InvalidResponseContent
    end

    # Headers prepared here.
    def headers
      { 'Authorization' => generate_bearer_token }
    end

    # Generate Bearer token from configuration.
    def generate_bearer_token
      "Bearer #{::EasyManageClient.configuration(profile).auth_token}"
    end

    # Parameters are prepared here.
    def params
      { version: ::EasyManageClient.configuration(profile).extension }
    end
  end
end
