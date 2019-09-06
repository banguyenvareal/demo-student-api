require 'rails_helper'

RSpec.describe Api, type: :request do
  describe 'delete a student' do
    let!(:student) { create(:student) }
    let(:user_id) { student.id }

    context 'student not exist' do
      let(:params) do
        { user_id: user_id}
      end

      subject do
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      it 'return status 404' do
        allow(Student).to receive(:find_by).with(anything).and_return(nil)
        subject
        expect(response.status).to eq 404
      end
    end

    context 'student exist' do
      let(:params) do
        { user_id: user_id}
      end

      subject do
        delete "/api/v1/students/#{ student.id }",
        params: params
        response
      end

      context 'params has only user_id ' do
        it 'return status 200' do
          subject
          binding.pry
          expect(response.status).to eq 200
        end

        it 'number students decrement by 1' do
          expect{ subject }.to change(Student, :count).by(-1)
        end
      end
    end

    # context 'params fully' do
    #   # let(:user_id) { rand(1..10) }
    #   context 'is_admin param is true' do
    #     let(:user_id) { rand(1..10) }
    #     let(:params) do
    #       { user_id: user_id, is_admin: 'true'}
    #     end

    #     subject do
    #       delete "/api/v1/students/#{ student.id }",
    #       params: params
    #       response
    #     end

    #     context 'student exist' do
    #       it 'return status 200' do
    #         subject
    #         expect(response.status).to eq 200
    #       end

    #       # it 'Display student has been deleted' do
    #       #   subject
    #       #   student = Student.find_by(id: Student.last.id)
    #       #   output = expect(JSON.parse(response.body)["student"])
    #       #   expect(output["id"]).to eq(student.id)
    #       # end

    #       it 'number students decrement by 1' do
    #         expect{ subject }.to change(Student, :count).by(-1)
    #       end
    #     end
    #   end
    # end
  end
end
