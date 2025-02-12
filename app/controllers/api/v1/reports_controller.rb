class Api::V1::ReportsController < ApplicationController
    before_action :authenticate_admin!

    # GET /api/v1/reports/spending
    def spendings
        # TODO:
    end

    # GET /api/v1/reports/cancellation
    def cancellations
        pagy, cards = pagy(
            Card.cancellations(from_date: params[:from_date], to_date: params[:to_date]).order(canceled_at: :desc)
        )

        render json: {
            data: CardSerializer.new(cards).serializable_hash[:data],
            pagination: PagySerializer.new(pagy).serializable_hash[:data]
        }
    end
end
