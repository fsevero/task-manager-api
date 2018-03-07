require 'rails_helper'

RSpec.describe 'Tasks API' do
  before { host! 'api.taskmanager.local' }
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token,
    }
  end


  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}.to_json, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 tasks from database' do
      expect(json_body[:data].count).to eq(5)
    end
  end

  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before { get "/tasks/#{task.id}", params: {}.to_json, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns json data for the task' do
      expect(json_body[:data][:attributes][:title]).to eq(task.title)
    end
  end

  describe 'POST /tasks' do
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers
    end

    context 'when params are valid' do
      let(:task_params) { attributes_for :task }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the task in de database' do
        expect( Task.find_by(title: task_params[:title]) ).not_to be_nil
      end

      it 'returns json data for the task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end

      it 'assigns the tasks to the correct user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when params are invalid' do
      let(:task_params) { attributes_for(:task, title: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not save the task in the database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end

      it 'returns json data for the errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'returns json data for the title error' do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe 'PUT /tasks/:id' do
    let!(:task) { create(:task, user_id: user.id) }
    before do
      put "/tasks/#{task.id}", params: {task: task_params}.to_json, headers: headers
    end

    context 'when parameters are valid' do
      let(:task_params) { {title: 'New task title'} }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for the updates task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end

      it 'updates the task in the database' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end
    end

    context 'when parameters are invalid' do
      let(:task_params) { {title: ' '} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns json data for the errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'returns json data for the title error' do
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'do not updates the task in the database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }

    before do
      delete "/tasks/#{task.id}", params: {}.to_json, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the tasks from the database' do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end