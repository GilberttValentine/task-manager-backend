require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, user_id: user.id) }
  let!(:tasks) { create_list(:task, 10, project_id: project.id) }
  let(:headers) { valid_headers }

  let(:user_id) { user.id }
  let(:project_id) { project.id }
  let(:id) { tasks.first.id }

  describe "GET /projects/:project_id/tasks" do
    before { get "/projects/#{project_id}/tasks", params: {}, headers: headers }

    context 'when project has tasks' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project tasks' do
        expect(json.size).to eq(10)
      end
    end

    context 'when the project has no tasks' do
      let(:tasks) { create_list(:task, 0) }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns none project tasks' do
        expect(json.size).to eq(0)
      end
    end

  end

  describe "GET /projects/:project_id/tasks/:id" do
    before { get "/projects/#{project_id}/tasks/#{id}", params: {}, headers: headers }

    context 'when task exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns task' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  describe "POST /projects/:project_id/tasks" do
    let(:valid_attributes) do 
      { name: 'Task test', description:'Description task', status: false, deadline: '2022-12-24' }.to_json
    end

    context 'when request attributes are valid' do
      before { post "/projects/#{project_id}/tasks", params: valid_attributes, headers:headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:invalid_attributes) do 
        { name: nil, description: nil, status: nil, deadline: nil }.to_json
      end

      before { post "/projects/#{project_id}/tasks", params: invalid_attributes, headers:headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank, Description can't be blank, Deadline can't be blank/)
      end
    end
  end

  describe "PUT /projects/:project_id/tasks/:id" do
    let(:valid_attributes) do 
      { name: 'Task test edited', description:'Description task edited', status: true, deadline: '2022-12-24' }.to_json
    end

    before { put "/projects/#{project_id}/tasks/#{id}", params: valid_attributes, headers: headers }

    context 'when request attributes are valid' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the task' do
        updated_task = Task.find(id)
        expect(updated_task.name).to match(/Task test edited/)
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:id" do
    before { delete "/projects/#{project_id}/tasks/#{id}", params: {}, headers: headers }

    context 'when delete project are successful' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the task is already deleted' do
      before { delete "/projects/#{project_id}/tasks/#{id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
