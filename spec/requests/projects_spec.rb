require 'rails_helper'

RSpec.describe "Projects", type: :request do
  # Initialize the test data
  let!(:user) { create(:user) }
  let!(:projects) { create_list(:project, 10, user_id: user.id) }
  let(:headers) { valid_headers }

  let(:id) { projects.first.id }

  describe "GET /projects" do
    before { get "/projects", params: {}, headers: headers }

    context 'when user has projects' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user projects' do
        expect(json.size).to eq(10)
      end
    end

    context 'when the user has no projects' do
      let(:projects) { create_list(:project, 0) }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns none user projects' do
        expect(json.size).to eq(0)
      end
    end
    
  end

  describe "GET /projects/:id" do
    before { get "/projects/#{id}", params: {}, headers: headers }

    context 'when user project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns project' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when user project does not exist' do
      let(:id) { 0 }
  
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
  
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end
  end

  describe "POST /projects" do
    let(:valid_attributes) do 
      { name: 'Project test', description:'Description test' ,status: false }.to_json 
    end

    context 'when request attributes are valid' do
      before { post "/projects", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      let(:invalid_attributes) do 
        { name: nil, description: nil }.to_json 
      end

      before { post "/projects", params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank, Description can't be blank/)
      end
    end
  end

  describe "PUT /projects/:id" do
    let(:valid_attributes) do 
      { name: 'Project test edited', description:'Description test edited' ,status: true }.to_json 
    end

    before { put "/projects/#{id}", params: valid_attributes, headers: headers }

    context 'when project exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the project' do
        updated_project = Project.find(id)
        expect(updated_project.name).to match(/Project test edited/)
      end
    end
  end

  describe "DELETE /projects/:id" do
    before { delete "/projects/#{id}", params: {}, headers: headers }

    context 'when delete project are successful' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the project is already deleted' do
      before { delete "/projects/#{id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

end
