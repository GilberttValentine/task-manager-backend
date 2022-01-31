require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, user_id: user.id) }
  let!(:task) { create(:task, project_id: project.id) }
  let!(:comments) { create_list(:comment, 10, user_id: user.id, task_id: task.id) }
  let(:headers) { valid_headers }

  let(:user_id) { user.id }
  let(:project_id) { project.id }
  let(:task_id) { task.id }
  let(:id) { comments.first.id }

  describe "GET /projects/:project_id/tasks/:task_id/comments" do
    before { get "/projects/#{project_id}/tasks/#{task_id}/comments", params: {}, headers: headers }

    context 'when task has comments' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all task comments' do
        expect(json.size).to eq(10)
      end
    end

    context 'when task has no comments' do
      let(:comments) { create_list(:comment, 0) }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns none task comments' do
        expect(json.size).to eq(0)
      end
    end
  end

  describe "POST /projects/:project_id/tasks/:task_id/comments" do
    let(:valid_attributes) do
      {  description:'Description test', user_id: user.id.to_s }.to_json
    end

    context 'when request attributes are valid' do
      before { post "/projects/#{project_id}/tasks/#{task_id}/comments", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:invalid_attributes) do 
        { description: nil, user_id: user.id.to_s }.to_json
      end

      before { post "/projects/#{project_id}/tasks/#{task_id}/comments", params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Description can't be blank/)
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:task_id/comments/:id" do
    before { delete "/projects/#{project_id}/tasks/#{task_id}/comments/#{id}", params: {}, headers: headers }

    context 'when delete comment are successful' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the comment is already deleted' do
      before { delete "/projects/#{project_id}/tasks/#{task_id}/comments/#{id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
