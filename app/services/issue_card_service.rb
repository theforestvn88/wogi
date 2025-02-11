# frozen_string_literal: true

class IssueCardService
    Result = Struct.new(:success, :card, :errors)

    def exec(card)
        card.activation_number = SecureRandom.hex(10)
        card.purchase_pin = 6.times.map { rand(10) }.join

        if card.save
            Result.new(true, card, nil)
        else
            Result.new(false, card, card.errors)
        end
    rescue => e
        Result.new(false, card, e)
    end
end
