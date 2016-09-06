class IdeasController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :find_idea, only: [:show, :edit, :update, :destroy]
  before_action :idea_params, only: [:create, :update]
  before_action :authorize!, only: [:update, :edit, :destroy]

  def index
    @limit ||= 25
    @charlim ||= 50
    @query = params[:query]
    @ideas = Idea.search(params[:query])
    @ideas = @ideas.order(created_at: :desc, id: :desc).page(params[:page]).per(@limit)
  end

  def show
    if user_signed_in?
      @comments = @idea.comments
      @comment = Comment.new
    else
      redirect_to new_session_path
    end
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.new idea_params
    @idea.user = current_user
    if @idea.save
      redirect_to root_path, notice: 'Idea added successfully.'
    else
      render :new, alert: @idea.errors.full_messages.join(', ')
    end
  end

  def edit

  end

  def update
    if @idea.update idea_params
      redirect_to idea_path(@idea), notice: 'Idea Edited Successfully'
    else
      render :edit, alert: @idea.errors.full_messages.join(', ')
    end
  end

  def destroy
    @idea.destroy
    redirect_to root_path, notice: 'Idea Deleted Successfully'
  end

  private

  def find_idea
    @idea = Idea.find params[:id]
  end

  def idea_params
    params.require(:idea).permit([:title, :body])
  end

  def error_messages
    @idea.errors.full_messages.join(', ')
  end

  def authorize!
    redirect_to idea_path(@idea), alert: 'Access Denied' unless can? :manage, @idea
  end

end
