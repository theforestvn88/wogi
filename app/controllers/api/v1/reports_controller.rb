class Api::V1::ReportsController < ApplicationController
    before_action :authenticate_admin!

    # GET /api/v1/reports/spending
    def spendings
        # TODO:
    end

    # GET /api/v1/reports/cancellation
    def cancellations
        cards = Card.cancellations(from_date: params[:from_date], to_date: params[:to_date]).order(canceled_at: :desc)
        render json: CardSerializer.new(cards).serializable_hash.to_json
    end
end
