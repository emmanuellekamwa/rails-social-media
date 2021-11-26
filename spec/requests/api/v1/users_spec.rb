require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[name email password password_confirmation]
      }

      response '201', 'user created' do
        let!(:user) { create(:user) }
      end
    end
  end
end
