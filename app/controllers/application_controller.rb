class ApplicationController < ActionController::API

  # Shared handlers for common errors
  #rescue_from ArgumentError, with :invalid_param
  rescue_from ActionController::ParameterMissing, with: :missing_param

  def missing_param
    render json: { error: 'Required parameter missing' }
  end

  def invalid_param
    render json: { error: 'Some parameters are invalid' }
  end

end
