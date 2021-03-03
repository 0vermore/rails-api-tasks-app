class ApiController < ActionController::API
    include Response
    include ExceptionHandler
    
    before_action :authorized

    def encode_token(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def auth_header
      if request.headers['Authorization'].present?
        return request.headers['Authorization'].split(' ').last
      else
        Rails.logger.info('Missing token')
      end
      nil
    end
  
    def decoded_token
      if auth_header
        token = auth_header
        # header: { 'Authorization': 'Bearer <token>' }
        begin
          JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        rescue JWT::DecodeError
          Rails.logger.info('Decode: nil')
          nil
        end
      end
    end
  
    def logged_in_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
      end
    end
  
    def logged_in?
      !!logged_in_user
    end
  
    def authorized
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

end
