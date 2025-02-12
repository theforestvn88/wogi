# frozen_string_literal: true

class PagySerializer
    include JSONAPI::Serializer

    set_id :page
    attributes :page, :pages, :count, :next, :prev
end
