# frozen_string_literal: true

class WebhookEventosController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  before_action :validate_token

  def create
    @event = WebhookEvento.new(webhook: @webhook, body: payload, headers: filtered_headers)

    if @event.save #&& EventWorker.perform_async(@event.id)
      render json: { status: 200 }
    else
      render json: { status: 404, error: 'generic error message that makes people mad' }, status: :bad_request
    end
  end

  private

  def validate_token
    return if (@endpoint = Webhook.find_by(token: params[:token]))

    response = { errors: { token: ['Unknown token'] } }
    render json: response, status: :unprocessable_entity
  end

  def payload
    params.except(:token, :event, :action, :controller)
  end

  def filtered_headers # rubocop:disable Metrics/MethodLength
    request.headers.env.reject do |key|
      key.to_s.include?('.')
    end.reject do |key|
      %w[
        GATEWAY_INTERFACE
        HTTP_AUTHORIZATION
        ORIGINAL_FULLPATH
        ORIGINAL_SCRIPT_NAME
        PATH_INFO
        QUERY_STRING
        RAW_POST_DATA
        REQUEST_PATH
        REQUEST_URI
        SCRIPT_NAME
        SERVER_SOFTWARE
        warden
      ].include? key
    end
  end
end