require 'rails_helper'

RSpec.describe Api, type: :request do
  describe 'get' do
    subject do
      get '/api/v1/students'
      response
    end

    context 'no exist any students' do
      it 'return status 204' do
        subject
        expect(response.status).to eq 204
      end
    end

    context 'many student exist' do
      before do
        10.times { create(:student) }
      end

      it 'return status 200' do
        subject
        expect(response.status).to eq 200
      end

      it 'return correct quantity' do
        subject
        expect(JSON.parse(response.body)["students"].count).to eq Student.count
      end

      it 'students display correctly' do
        subject
        expect(JSON.parse(response.body)["students"]).to eq Student.select(:id, :name, :user_id).as_json
      end
    end
  end
end
