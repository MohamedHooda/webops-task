class PostsController < ApplicationController
    require 'json'
    before_action :authorize_post, only: [:update, :delete]

    def create
        body = params[:body]
        title = params[:title]
        tags = params[:tags]
        puts tags.class.inspect
        if tags.class != Array || tags.size == 0
            render json: {error:"tags should be an array that has elements"}
        else
            
            tags = {data:params[:tags]}
            # tags = JSON.parse({data: tags})
            puts tags.inspect
            user_id = @user.id
            puts user_id.inspect

            @post = Post.create(body:body, title:title, author_id: user_id, tags:tags)
            PostWorker.perform_at(1.minutes.from_now, @post.id)
            render json: {data: {post_id:@post.id, title:@post.title, body:@post.body, tags:@post.tags}}
    
        end
    end

    def update
        tags_body = params[:tags]
        
        if tags_body
            if tags_body.class != Array || tags_body.size == 0
                render json: {error:"tags should be an array that has elements"}
            else
                if params[:body]
                    @post.body = params[:body]
                end
                if params[:title]
                    @post.title = params[:title]
                end
                @post.tags = {data:tags_body}
                @post.save
                render json: {data: {title:@post.title, body:@post.body,tags:@post.tags}}
            end
        else
            if params[:body]
                @post.body = params[:body]
            end
            if params[:title]
                @post.title = params[:title]
            end
            @post.save
            render json: {data: {title:@post.title, body:@post.body, tags:@post.tags}}
        end

        
    end

    def delete
        @post.destroy
        render json: {data: "deleted successfully"}
    end

    def get
        posts = Post.all()
        posts_response = []
        for i in posts
            post_id = i.id
            author_id = i.author_id
            body = i.body
            title = i.title
            
            posts_response.append({post_id:post_id, title:title, body:body, title:title})
        end
        render json:{data:posts_response}
    end

    private
  
    def post_params
      params.permit(:body, :title, :tags)
    end

    def authorize_post
        @post = Post.find_by(id:params[:post_id])
        if !@post
            render json: { error: "post not found" }
        else
            if @post.author_id != @user.id
                render json: { error: "not authorized" }
            end
        end
    end

end
