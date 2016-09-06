class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session["user_id"] = @user.id
      redirect_to root_path, notice: "Sign Up Successful"
    else
      flash[:alert] = "Error"
      render :new
    end
  end

  def show

  end

  def destroy

  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
