class CommentsController < ApplicationController
    before_action :authorize_comment, only: [:update, :delete]

    def create
        user_id = @user.id
        post_id = params[:post_id]
        comment = params[:text]
        post = Post.find_by(id:post_id)
        if !post
            render json: {error:"post not found"}
        else
            @comment = Comment.create(text:comment, author_id:user_id, post_id:post_id)
            render json: { data: { comment: @comment.text, post_id: @comment.post_id, user_id: @comment.author_id } }
        end
    end

    def update
        if params[:text]
            @comment.update(text:params[:text])
        end
        render json: { data: { comment: @comment.text, post_id: @comment.post_id, user_id: @comment.author_id } }
    end


    def delete

        @comment.destroy
        render json: { data: "comment deleted" }
    end

    

    private
  
    def comment_params
      params.permit(:text, :post_id)
    end

    def authorize_comment
        @comment = Comment.find_by(id:params[:comment_id])
        if !@comment
            render json: { error: "comment not found" }
        else
            if @comment.author_id != @user.id
                render json: { error: "not authorized" }
            end
        end
    end

  

end
