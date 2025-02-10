# frozen_string_literal: true

module Api
  module V1
    module Auth
      class PasswordsController < DeviseTokenAuth::PasswordsController
      end
    end
  end
end
