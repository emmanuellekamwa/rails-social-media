class Api::V1::CommentsController < Api::V1::ApiController
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments
    render json: @comments
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.post_id = params[:post_id]
    @comment.user = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :bad_request, message: 'Operation failed'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
