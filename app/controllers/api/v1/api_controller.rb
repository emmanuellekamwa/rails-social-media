class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render json: { error: 'Record not found' }, status: 404
  end
end
