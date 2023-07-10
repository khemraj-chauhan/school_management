module ApplicationMethods
  extend ActiveSupport::Concern

  included do
    around_action :handle_exceptions, if: -> { request.format.json? }
  end

  private

  def handle_exceptions
    begin
      yield
    rescue ActiveRecord::RecordNotFound => exception
      @status = 404
    rescue ActiveRecord::RecordInvalid => exception
      render_unprocessable_entity_response(exception.record) && return
    rescue ArgumentError => exception
      track_error(exception)
      @status = 400
    rescue StandardError => exception
      @status = 500
    end
    detail = { detail: exception.try(:message) }
    detail[:trace] = exception.try(:backtrace) if Rails.env.development?

    respond_to do |format|
      format.html
      format.json {json_response({ success: false, message: exception.class.to_s, errors: [detail] }, @status) unless exception.instance_of?(NilClass)}
    end
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end
end
