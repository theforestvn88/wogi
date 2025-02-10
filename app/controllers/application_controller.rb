class ApplicationController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :response_unauthorized

    private

        def response_unauthorized
            render json: {}, status: :unauthorized
        end
end
