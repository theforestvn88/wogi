class Api::V1::CustomFieldsController < ApplicationController
    before_action :authenticate_admin!

    # POST /api/v1/brands/1/custom_fields
    def create
        result = AddCustomFieldService.new.add(custom_field_params)
        if result.success
          head :created
        else
          render json: { errors: Array.wrap(result.errors) }, status: :unprocessable_entity
        end
    rescue => e
        render :bad_request
    end

    # DELETE /api/v1/brands/1/custom_fields/1
    def destroy
        @custom_field = find_custom_field
        @custom_field.destroy!
        head :no_content
    end

    private

        def find_custom_field
            CustomField.find(params[:id])
        end

        def custom_field_params
            @custom_field_params ||= params.require(:custom_field).permit(:customable_id, :customable_type, :field_name, :field_type)
        end
end
