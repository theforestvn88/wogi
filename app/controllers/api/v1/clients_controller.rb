class Api::V1::ClientsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_client, only: %i[ destroy ]

  # POST /clients
  def create
    @client = Client.new(client_params)

    authorize @client

    if @client.save
      render json: @client, status: :created, location: api_v1_client_url(@client)
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
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:user_id, :payout_rate)
    end

    def assign_params
      params.require(:product).permit(:id)
    end
end
