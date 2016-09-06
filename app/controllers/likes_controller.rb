class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_idea, only: [:create, :destroy]

  def create
    like = Like.new user: current_user, idea: @idea
    if cannot? :like, @idea
      redirect_to idea_path(@idea), alert: "Cannot like your own idea"
    elsif like.save
      redirect_to idea_path(@idea), notice: "Liked"
    else
      redirect_to idea_path(@idea), alert: "You Fucked Up"
    end
  end

  def destroy
    like = Like.find params[:id]
    if can? :destroy, like
      like.destroy
      redirect_to idea_path(@idea), notice: "Disliked"
    else
      redirect_to idea_path(@idea), alert: "access denied!"
    end
  end

  private

  def find_idea
    @idea = Idea.find params[:idea_id]
  end

end
