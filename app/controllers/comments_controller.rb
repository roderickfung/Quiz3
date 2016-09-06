class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_idea, except: [:update]
  before_action :find_comment, only: [:edit, :show, :destroy]

  def create
    @idea = Idea.find params[:idea_id]
    @comment = Comment.new comment_params
    @comment.idea_id = @idea.id
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html{
          redirect_to idea_path(@idea), notice: 'Review Saved'
        }
        format.js{
          render :create
        }
      else
        format.html{
          redirect_to idea_path(@idea), alert: 'Review Not Saved'
        }
        format.js{
          render :create_not_saved
        }
      end
    end
  end

  def edit

  end

  def index

  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html{
        redirect_to idea_path(@idea), notice: "Idea Deleted Successfully"
      }
      format.js{
        render
      }
    end
  end

  private

  def find_idea
    @idea = Idea.find params[:idea_id]
  end

  def find_comment
    @comment = Comment.find params[:id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
