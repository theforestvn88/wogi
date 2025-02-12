# frozen_string_literal: true

class CustomField < ApplicationRecord
    belongs_to :customable, polymorphic: true, counter_cache: :custom_fields_count

    validates_presence_of :field_name, :field_type
end
