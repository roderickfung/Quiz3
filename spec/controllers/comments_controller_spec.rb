require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:idea)    { FactoryGirl.create :idea }
  let(:user) { FactoryGirl.create :user }

  let(:comment) { FactoryGirl.create :comment, {user: user}}
  let(:user2) { FactoryGirl.create :user }

  let(:idea2) { FactoryGirl.create :idea, {user: user2}}
  let(:comment2) {FactoryGirl.create :comment, {idea: idea2, user: user}}

  describe '#create' do
    context 'with no signed in user' do
      it 'directs to sign in page' do
        post :create, params: {body: 'RSPEC Test', idea_id: idea.id}
        expect(response).to redirect_to new_session_path
      end
    end

    context 'with signed in user' do
      before {request.session[:user_id] = user.id}

      context 'with valid attributes' do
        def valid_request
          post :create, params: {comment: {body: 'Testing 123'}, user_id: user.id, idea_id: idea.id}
        end

        it 'creates a comment in the database' do
          count_before = Comment.count
          valid_request
          count_after = Comment.count
          expect(count_after).to eq(count_before + 1)
        end

        it 'redirects to the idea show page' do
          valid_request
          expect(response).to redirect_to idea_path(idea)
        end

        it 'associate the created comment with the logged in user' do
          valid_request
          expect(Comment.last.user).to eq(user)
        end

        it 'associate the created comment with the idea' do
          valid_request
          expect(Comment.last.idea).to eq(idea)
        end
      end

      context 'with invalid attributes' do
        def invalid_request
          post :create, params: {comment: {body: ''}, user_id: user.id, idea_id: idea.id}
        end

        it "doesn't create the comment in the database" do
          count_before = Comment.count
          invalid_request
          count_after = Comment.count
          expect(count_after).to eq(count_before)
        end
      end

    end
  end

  describe '#destroy' do
    context 'with no signed in user' do
      it 'redirects to log in screen' do
        delete :destroy, params: {id: comment.id, idea_id: comment.idea.id}
        expect(response).to redirect_to new_session_path
      end
    end

    context 'with signed in user' do
      before { request.session[:user_id] = user.id }
      it 'removes the comment record from the database' do
        comment #calls method defined by the let
        count_before = Comment.count
        delete :destroy, params: {id: comment.id, idea_id: comment.idea.id}
        count_after = Comment.count
        expect(count_after).to eq(count_before-1)
      end

      it 'redirects back to the show page' do
        comment
        delete :destroy, params: {id: comment.id, idea_id: comment.idea.id}
        expect(response).to redirect_to idea_path(comment.idea)
      end
    end

    context 'with wrong user' do
      before { request.session[:user_id] = user2.id }
      it 'does not remove comment record from the database' do
        comment
        count_before = Comment.count
        delete :destroy, params: {id: comment.id, idea_id: comment.idea.id}
        count_after = Comment.count
        expect(count_after).to eq(count_before)
      end
    end

    context 'with idea.user' do
      before { request.session[:user_id] = user2.id}
      it 'removes the comment record from the database' do
        comment2
        count_before = Comment.count
        delete :destroy, params: {id: comment2.id, idea_id: comment2.idea.id }
        count_after = Comment.count
        expect(count_after).to eq(count_before-1)
      end
    end

  end
end
