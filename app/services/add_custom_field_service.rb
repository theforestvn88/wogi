# frozen_string_literal: true

class AddCustomFieldService
    Result = Struct.new(:success, :custom_field, :errors)

    def add(custom_field_params)
        customable = find_customable(custom_field_params)
        raise ArgumentError unless customable.active?
        raise ActiveRecord::RecordInvalid unless customable.custom_fields_count < 5

        custom_field = CustomField.new(custom_field_params)

        if custom_field.save
            Result.new(true, custom_field, nil)
        else
            Result.new(false, custom_field, custom_field.errors)
        end
    rescue => e
        Result.new(false, nil, e)
    end

    private

        def find_customable(custom_field_params)
            custom_field_params[:customable_type].classify.constantize.find(custom_field_params[:customable_id])
        end
end
