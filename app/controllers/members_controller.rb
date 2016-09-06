class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_idea, only: [:create, :destroy]

  def create
    member = Member.new user: current_user, idea: @idea
    if cannot? :member, @idea
      redirect_to idea_path(@idea), alert: "Cannot follow your own idea"
    elsif member.save
      redirect_to idea_path(@idea), notice: "Followed"
    else
      redirect_to idea_path(@idea), alert: "You Fucked Up"
    end
  end

  def destroy
    member = Member.find params[:id]
    if can? :destroy, member
      member.destroy
      redirect_to idea_path(@idea), notice: "Unfollowed"
    else
      redirect_to idea_path(@idea), alert: "access denied!"
    end
  end

  private

  def find_idea
    @idea = Idea.find params[:idea_id]
  end

end
