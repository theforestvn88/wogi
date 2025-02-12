class Api::V1::CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, only: %i[ active cancel ]

  # POST /cards
  def create
    @card = Card.new(card_params)
    @card.user = current_user

    authorize @card

    result = IssueCardService.new.exec(@card)
    if result.success
      render json: card_json(result.card), status: :created
    else
      render json: { errors: Array.wrap(result.errors) }, status: :unprocessable_entity
    end
  end

  # PATCH /cards/1/active
  def active
    raise ArgumentError if params[:activation_number] != @card.activation_number

    authorize @card

    result = ActiveCardService.new.exec(@card)

    if result.success
      render json: card_json(result.card)
    else
      render json: { errors: Array.wrap(result.errors) }, status: :unprocessable_entity
    end
  end

  # PATCH /cards/1/cancel
  def cancel
    authorize @card

    result = CancelCardService.new.exec(@card)
    if result.success
      render json: card_json(result.card)
    else
      render json: { errors: Array.wrap(result.errors) }, status: :unprocessable_entity
    end
  end

  private

    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:product_id)
    end

    def card_json(card_data)
      CardSerializer.new(card_data).serializable_hash.to_json
    end
end
