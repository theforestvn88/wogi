class Api::V1::AccessSessionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_access_session, only: %i[ destroy ]

  # POST /assignments
  def create
    result = AssignClientToProductService.new.exec(**access_session_params.to_h.symbolize_keys)

    if result.success
      render json: result.access_session, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  # DELETE /assignments/1
  def destroy
    @access_session.destroy!
    head :no_content
  end

  private

    def set_access_session
      @access_session = AccessSession.find(params[:id])
    end

    def access_session_params
      params.require(:access_session).permit(:user_id, :product_id, :duration)
    end
end
