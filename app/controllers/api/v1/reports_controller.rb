class Api::V1::ReportsController < ApplicationController
    include Pagy::Backend

    before_action :authenticate_admin!

    # GET /api/v1/reports/spending
    def spendings
        # TODO:
    end

    # GET /api/v1/reports/cancellation
    def cancellations
        pagy, cards = Rails.cache.fetch(report_cancellations_cache_key, expires_in: 1.day) do
            pagy(
                Card.cancellations(from_date: params[:from_date], to_date: params[:to_date]).order(canceled_at: :desc)
            )
        end

        render json: {
            data: CardSerializer.new(cards).serializable_hash[:data],
            pagination: PagySerializer.new(pagy).serializable_hash[:data]
        }
    end

    private

        def report_cancellations_cache_key
            "report-cancellations-#{params[:from_date]}-#{params[:to_date]}-page#{params[:page] || 1}"
        end
end
