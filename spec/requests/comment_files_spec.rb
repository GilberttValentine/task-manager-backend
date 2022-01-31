require 'rails_helper'

RSpec.describe "CommentFiles", type: :request do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, user_id: user.id) }
  let!(:task) { create(:task, project_id: project.id) }
  let!(:comment) { create(:comment, user_id: user.id, task_id: task.id) }
  let!(:comment_files) { create_list(:comment_file, 10, comment_id: comment.id) }
  let(:headers) { valid_headers }

  let(:user_id) { user.id }
  let(:project_id) { project.id }
  let(:task_id) { task.id }
  let(:comment_id) { comment.id }
  let(:id) { comment_files.first.id }

  describe "GET /projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files" do
    before { get "/projects/#{project_id}/tasks/#{task_id}/comments/#{comment_id}/comment_files", params: {}, headers: headers }

    context 'when comment has files' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all comment files' do
        expect(json.size).to eq(10)
      end
    end

    context 'when comment has no files' do
      let(:comment_files) { create_list(:comment_file, 0) }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns none comment files' do
        expect(json.size).to eq(0)
      end
    end
  end

  describe "GET /projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files/:id" do
    before { get "/projects/#{project_id}/tasks/#{task_id}/comments/#{comment_id}/comment_files/#{id}", params: {}, headers: headers }

    context 'when comment file exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns file' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when comment file does not exist' do
      let(:id) { 0 }
  
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
  
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find CommentFile/)
      end
    end
  end

  describe "POST /projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files" do
    let(:valid_attributes) do
      {  url:'Url test' }.to_json
    end

    context 'when request attributes are valid' do
      before { post "/projects/#{project_id}/tasks/#{task_id}/comments/#{comment_id}/comment_files", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:invalid_attributes) { { url: nil }.to_json }

      before { post "/projects/#{project_id}/tasks/#{task_id}/comments/#{comment_id}/comment_files", params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Url can't be blank/)
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:task_id/comments/:comment_id/comment_files/:id" do
    before { delete "/projects/#{project_id}/tasks/#{task_id}/comments/#{comment_id}/comment_files/#{id}", params: {}, headers: headers }

    context 'when delete comment file are successful' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when comment file is already deleted' do
      before { delete "/projects/#{project_id}/tasks/#{task_id}/comments/#{comment_id}/comment_files/#{id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
