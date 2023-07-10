require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let(:school) { create(:school) }

  let(:school_admin) do
    user = create(:user)
    role = create(:role, name: "school_admin")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    create(:school_admin, school_id: school.id, admin_id: user.id)
    user
  end

  let(:student) do
    user = create(:user)
    role = create(:role, name: "student")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    user
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:set_current_user).and_return(nil)
  end

  describe "GET /index" do
    context "should return the list of courses" do
      it "when request is called by admin" do
        sign_in(school_admin)
        course = create(:course, school_id: school.id)
        get "/schools/#{school.id}/courses.json"

        result = JSON.parse(response.body)
        expect(result[0]["id"]).to eq(course.id)
        expect(result[0]["school_name"]).to eq(school.name)
      end
    end
  end

  describe "POST /create" do
    context "should return newly created course" do
      it "when request is called by admin" do
        course_params = {
            "course": {
                "title": "Computer Science",
                "description": "course of IT preparation"
            }
          }
        sign_in(school_admin)
        post "/schools/#{school.id}/courses.json", params: course_params

        result = JSON.parse(response.body)
        expect(result["title"]).to eq(course_params[:course][:title])
        expect(result["id"]).to be_present
      end
    end
  end

  describe "PUT /update" do
    context "should return updated course" do
      it "when request is called by admin" do
        course_params = {
            "course": {
                "title": "Updated Computer Science",
                "description": "Updated course of IT preparation"
            }
          }
        sign_in(school_admin)
        course = create(:course, school_id: school.id)
        put "/schools/#{school.id}/courses/#{course.id}.json", params: course_params

        result = JSON.parse(response.body)
        expect(result["title"]).to eq(course_params[:course][:title])
        expect(result["id"]).to eq(course.id)
      end
    end
  end

  describe "DELETE /DESTROY" do
    context "delete request" do
      it "should not delete school when request is called by student" do
        school
        sign_in(student)
        course = create(:course, school_id: school.id)
        delete "/schools/#{school.id}/courses/#{course.id}.json"

        result = JSON.parse(response.body)
        expect(result["data"]).to eq([])
        expect(result["error"]).to eq("You are not authorize user")
      end

      it "should delete school when request is called by admin" do
        school
        sign_in(school_admin)
        course = create(:course, school_id: school.id)
        delete "/schools/#{school.id}/courses/#{course.id}.json"

        result = JSON.parse(response.body)
        expect(result["data"]).to eq([])
        expect(result["message"]).to eq("Course was successfully destroyed.")
      end
    end
  end

  describe "GET /SHOW" do
    context "should return specific course details" do
      it "when request is called by admin or school admin" do
        school
        sign_in(school_admin)
        course = create(:course, school_id: school.id)
        get "/schools/#{school.id}/courses/#{course.id}.json"

        result = JSON.parse(response.body)
        expect(result["id"]).to eq(course.id)
        expect(result["title"]).to eq(course.title)
      end
    end
  end
end
