require 'swagger_helper'

RSpec.describe 'api/v1/comments', type: :request do
  path '/api/v1/posts/{post_id}/comments?auth_token={auth_token}' do
    parameter name: 'post_id', in: :path, type: :integer, description: 'post_id'
    parameter name: 'auth_token', in: :path, type: :string, description: 'auth_token'

    get 'Retrieves all comments for a post' do
      tags 'Comments'
      produces 'application/json'
      response('200', 'Comments retrieved') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   content: { type: :string },
                   user_id: { type: :integer },
                   post_id: { type: :integer },
                   created_at: { type: :string },
                   updated_at: { type: :string }
                 }
               }
        let!(:user) { create(:user) }
        let!(:new_post) { user.posts.create(content: 'This is my new post') }
        let(:auth_token) { user.authentication_token }
        let(:post_id) { new_post.id }
        let(:comment) { { content: 'I like this post a lot!!' } }
        run_test!
      end
    end

    post('Creates a comment') do
      tags 'Comments'
      consumes 'application/json'
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          content: { type: :string, example: 'This is a comment' }
        },
        required: %w[content]
      }

      response(200, 'comment created') do
        let!(:user) { create(:user) }
        let!(:new_post) { user.posts.create(content: 'This is my new post') }
        let(:auth_token) { user.authentication_token }
        let(:post_id) { new_post.id }
        let(:comment) { { content: 'I like this post a lot!!' } }
        run_test!
      end

      response(400, 'comment not created') do
        let!(:user) { create(:user) }
        let!(:new_post) { user.posts.create(content: 'This is my new post') }
        let(:auth_token) { user.authentication_token }
        let(:post_id) { new_post.id }
        let(:comment) { { content: '' } }
        run_test!
      end
    end
  end
end