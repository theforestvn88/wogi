class Brand < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: :user_id
    has_many :products, dependent: :destroy
    has_many :custom_fields, as: :customable

    validates_presence_of :name

    enum :state, {
        active: "active",
        inactive: "inactive"
    }
end
