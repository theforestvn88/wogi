class ApplicationController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError,          with: :response_unauthorized
    rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
    rescue_from ActiveRecord::RecordNotUnique,       with: :render_record_not_unique
    rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
    rescue_from ArgumentError,                       with: :render_argument_error
    rescue_from Pagy::OverflowError,                 with: :render_paging_overflow

    private

        def response_unauthorized
            render json: {}, status: :unauthorized
        end

        def render_not_found(exception)
            render_error(exception, { message: I18n.t("api.errors.not_found") }, :not_found)
        end

        def render_record_invalid(exception)
            render_error(exception, exception.record&.errors&.as_json || { message: I18n.t("api.errors.invalid_input") }, :unprocessable_entity)
        end

        def render_record_not_unique(exception)
            render_error(exception, { message: I18n.t("api.errors.record_not_unique") }, :unprocessable_entity)
        end

        def render_parameter_missing(exception)
            render_error(exception, { message: I18n.t("api.errors.missing_param") }, :unprocessable_entity)
        end

        def render_argument_error(exception)
            render_error(exception, { message: I18n.t("api.errors.invalid_input") }, :bad_request)
        end

        def render_error(exception, errors, status)
            logger.info { exception }
            render json: { errors: Array.wrap(errors) }, status:
        end

        def render_paging_overflow
            render json: { error: "Page out of range" }, status: :not_found
        end

        def authenticate_admin!
            authenticate_user!
            raise Pundit::NotAuthorizedError unless current_user.is_admin
        end
end
