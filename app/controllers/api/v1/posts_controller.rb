class Api::V1::PostsController < Api::V1::ApiController
  before_action :authenticate_user!

  def show
    @post = Post.find(params[:id])
    render json: @post, status: 200
  end

  def index
    @posts = Post.all
    render json: @posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      render json: @post, status: 201
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
