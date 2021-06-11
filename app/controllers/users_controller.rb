class UsersController < ApplicationController
    before_action :authorized, only: []
  
    # REGISTER
    def create

      @user_exists = User.find_by(email: params[:email])


      if @user_exists
        render json: {error: "Email already exists"}
      else  
        @user = User.create(user_params)

        if @user.valid?
          token = encode_token({user_id: @user.id})
          render json: {email:@user.email, name:@user.name, image:@user.image, token: token}
        else
          render json: {error: "Invalid email or password"}
        end
      end
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(email: params[:email])
  
    #   puts @user.inspect
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id, email:@user.email, image:@user.image})
        render json: {email:@user.email, name:@user.name, image:@user.image, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
  
    private
  
    def user_params
      params.permit(:email, :password, :image, :name)
    end
  
  end