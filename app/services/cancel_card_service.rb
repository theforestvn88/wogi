# frozen_string_literal: true

class CancelCardService
    Result = Struct.new(:success, :card, :errors)

    def exec(card)
        card.state = :canceled
        card.canceled_at = Time.now.utc

        if card.save
            Result.new(true, card, nil)
        else
            Result.new(false, card, card.errors)
        end
    rescue => e
        Result.new(false, card, e)
    end
end
