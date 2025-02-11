# frozen_string_literal: true

class ActiveCardService
    Result = Struct.new(:success, :card, :errors)

    def exec(card)
        card.state = :active

        if card.save
            Result.new(true, card, nil)
        else
            Result.new(false, card, card.errors)
        end
    rescue => e
        Result.new(false, card, e)
    end
end
