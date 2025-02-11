# frozen_string_literal: true

module OnwerPolicy
    def update?
        owner?
    end

    def update_state?
        owner?
    end

    def destroy?
        owner?
    end

    private

        def owner?
            @user.id == @record.user_id
        end
end
