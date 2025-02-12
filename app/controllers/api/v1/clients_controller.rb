class Api::V1::ClientsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_client, only: %i[ destroy ]

  # POST /clients
  def create
    @client = User.new(client_params)

    authorize @client

    if @client.save
      render json: @client, status: :created
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    authorize @client

    @client.destroy!
    head :no_content
  end

  private

    def set_client
      @client = User.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:email, :password, :payout_rate)
    end

    def assign_params
      params.require(:product).permit(:id)
    end
end
