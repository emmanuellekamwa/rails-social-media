require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do
  path '/api/v1/posts?auth_token={auth_token}' do
    post 'Creates a post' do
      tags 'Posts'
      consumes 'application/json'
      parameter name: 'auth_token', in: :path, type: :string, description: 'auth_token'
      parameter name: :new_post, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, example: 'This is a comment' }
        },
        required: %w[content]
      }

      response(201, 'post created') do
        let!(:user) { create(:user) }
        let!(:new_post) { user.posts.create(content: 'This is my new post') }
        let(:auth_token) { user.authentication_token }
        run_test!
      end

      response(422, 'post not created') do
        let!(:user) { create(:user) }
        let!(:new_post) { user.posts.create(content: '') }
        let(:auth_token) { user.authentication_token }
        run_test!
      end
    end

    get 'Retrieves all posts' do
      tags 'Posts'
      produces 'application/json'
      parameter name: 'auth_token', in: :path, type: :string, description: 'auth_token'

      response('200', 'posts retrieved') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   comment: { type: :string },
                   user_id: { type: :integer },
                   post_id: { type: :integer },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }
               }
        let!(:user) { create(:user) }
        let(:auth_token) { user.authentication_token }
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}?auth_token={auth_token}' do
    get 'Retrieves a post' do
      tags 'Posts'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'id'
      parameter name: 'auth_token', in: :path, type: :string, description: 'auth_token'

      response '200', 'post found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 user_id: { type: :integer },
                 content: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[id]
        let!(:user) { create(:user) }
        let(:auth_token) { user.authentication_token }
        let(:id) { Post.create(user_id: user.id, content: 'My Post').id }
        run_test!
      end

      response '404', 'post not found' do
        let!(:user) { create(:user) }
        let(:auth_token) { user.authentication_token }
        let!(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
