class CommentsController < ApplicationController
  before_action :set_post
  skip_before_action :authorize

  # POST /posts/comments
  def add
    comment = Comment.new(comment_params)
    comment.post = @post
    comment.save
    redirect_to post_path(@post)
  end

  # PATCH /posts/comments/:permalink
  def update
  end

  # DELETE /posts/comments/:permalink
  def delete
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :email, :body)
  end

  def set_post
    @post = Post.find_by(permalink: params[:permalink])
  end
end
