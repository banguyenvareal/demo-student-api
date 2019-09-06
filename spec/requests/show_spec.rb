require 'rails_helper'

RSpec.describe Api, type: :request do

  describe "get" do
    let!(:student) { create(:student) }

    context 'student not exist' do
      subject do
        get "/api/v1/students/#{student.id + 1}"
        response
      end

      it 'returns a status by id' do
        subject
        expect(response.status).to eq 404
      end
    end

    context 'student exist' do
      subject do
        get "/api/v1/students/#{student.id}"
        response
      end
      it 'return a status 200' do
        subject
        expect(response.status).to eq 200
      end

      it 'return correct data' do
        subject
        output = JSON.parse(response.body)["student"]
        expect(output["id"]).to eq student.id
        expect(output["name"]).to eq student.name
        expect(output["user_id"]).to eq student.user_id
      end
    end
  end
end
