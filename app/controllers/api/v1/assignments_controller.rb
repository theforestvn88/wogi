class Api::V1::AssignmentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_assignment, only: %i[ destroy ]

  # POST /assignments
  def create
    result = AssignClientToProductService.new.exec(**assignment_params.to_h.symbolize_keys)

    if result.success
      render json: result.assignment, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  # DELETE /assignments/1
  def destroy
    @assignment.destroy!
  end

  private
    
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def assignment_params
      params.require(:assignment).permit(:client_id, :product_id, :duration)
    end
end
