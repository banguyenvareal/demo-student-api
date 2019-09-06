class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  helpers do
    params :control_params do
      at_least_one_of :user_id, :is_admin
    end
  end

  helpers do
    def delete_student_with_user_id(user_id, student)
      student.destroy! if user_id.to_i == student.user_id
    end

    def update_student(student, new_name)
      student.update({ name: new_name })
    end

    def update_student_with_user_id(student, user_id, new_name)
      return student.update({ name: new_name }) if user_id.to_i == student.user_id
    end
  end

  resource :students do
    desc 'List students'

    get do
      students = Student.all
      if students.empty?
        status 204
      else
        students
      end
    end

    desc 'Create a new stuent'

    params do
      requires :name, type: String, allow_blank: false
      requires :user_id, type: Integer, allow_blank: false
    end

    post do
      Student.create({
        name: params[:name],
        user_id: params[:user_id]
      })
    end

    desc 'delete a student'

    params do
      requires :id, type: String
      use :control_params
    end

    delete ':id' do
      student = Student.find_by(id: params[:id])
      return status(404) unless student

      if params.has_key?(:user_id) && params.has_key?(:is_admin)
        if params[:is_admin] == "true"
          student.destroy!
        else
          delete_student_with_user_id(params[:user_id], student)
        end

      elsif params.has_key?(:user_id)
         delete_student_with_user_id(params[:user_id], student)

      elsif params.has_key?(:is_admin)
        student.destroy! if params[:is_admin] == "true"
      end
    end

    desc 'update a student'

    params do
      requires :id, type: String
      requires :name, type: String, allow_blank: false
      use :control_params
    end

    put ':id' do
      student = Student.find_by(id: params[:id])
      return status(404) unless student

      if params.has_key?(:user_id) && params.has_key?(:is_admin)
        if params[:is_admin] == "true"
          if update_student(student, params[:name])
            student
          else
            status 400
          end
        else
          if update_student_with_user_id(student, params[:user_id], params[:name])
          student
        else
          status 400
        end
      end

      elsif params.has_key?(:user_id)
        if update_student_with_user_id(student, params[:user_id], params[:name])
          student
        else
          status 400
        end

      elsif params.has_key?(:is_admin)
        student if update_student(student, params[:name])
      end
    end

    desc 'show a student'

    params do
      requires :id, type: String
    end

    get ':id' do
      student = Student.find_by(id: params[:id])
      return student if student
      status 404
    end
  end
end
