class Brand < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: :user_id
    has_many :products, dependent: :destroy

    validates_presence_of :name

    enum :state, {
        active: "active",
        inactive: "inactive"
    }
end
