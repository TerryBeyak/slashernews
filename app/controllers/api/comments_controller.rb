module Api
  class CommentsController < ApplicationController
    before_filter :authenticate_user!, only: [:create, :upvote]

    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.create(comment_params.merge(user_id: current_user.id))

      respond_to do |format| 
        format.json { render json: @comment } 
      end
    end

    def upvote
      comment = Comment.find(params[:id])
      comment.increment!(:upvotes)

      respond_to do |format| 
        format.json { render json: @comment } 
      end
    end

    def destroy
      comment = Comment.find(params[:id])
      if post.users.include? current_user
        respond_with Post.destroy(params[:post_id])
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def default_serializer_options
      {root: false}
    end
  end
end