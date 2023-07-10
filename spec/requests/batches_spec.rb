require 'rails_helper'

RSpec.describe "Batches", type: :request do
  let(:school) { create(:school) }

  let(:school_admin) do
    user = create(:user)
    role = create(:role, name: "school_admin")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    create(:school_admin, school_id: school.id, admin_id: user.id)
    @course = create(:course, school_id: school.id)
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
    context "should return the list of Batches" do
      it "when request is called by admin" do
        sign_in(school_admin)
        batch = create(:batch, course_id: @course.id)
        get "/batches.json", params: {course_id: @course.id}

        result = JSON.parse(response.body)
        expect(result[0]["id"]).to eq(batch.id)
        expect(result[0]["course"]["id"]).to eq(@course.id)
      end
    end
  end

  describe "POST /create" do
    context "should return newly created batch" do
      it "when request is called by admin" do
        course = create(:course, school_id: school.id)
        batch_params = {
            "course_id": course.id, 
            "batch": {
                "name": "morning Batch",
                "description": "This batch will start from evening shift",
                "course_id": "#{course.id}"
            }
          }
        sign_in(school_admin)
        post "/batches.json", params: batch_params

        result = JSON.parse(response.body)
        expect(result["name"]).to eq(batch_params[:batch][:name])
        expect(result["id"]).to be_present
      end
    end
  end

  describe "PUT /update" do
    context "should return updated batch" do
      it "when request is called by admin" do
        course = create(:course, school_id: school.id)
        batch = create(:batch, course_id: course.id)
        batch_params = {
            "course_id": course.id, 
            "batch": {
                "name": "Updated morning Batch",
                "description": "Updated This batch will start from evening shift",
                "course_id": "#{course.id}"
            }
          }
        sign_in(school_admin)
        put "/batches/#{batch.id}.json", params: batch_params

        result = JSON.parse(response.body)
        expect(result["name"]).to eq(batch_params[:batch][:name])
        expect(result["id"]).to eq(batch.id)
        expect(result["course"]["id"]).to eq(course.id)
      end
    end
  end

  describe "GET /SHOW" do
    context "should return specific batch details" do
      it "when request is called by admin or school admin" do
        school
        sign_in(school_admin)
        course = create(:course, school_id: school.id)
        batch = create(:batch, course_id: course.id)
        get "/batches/#{batch.id}.json", params: {course_id: course.id}

        result = JSON.parse(response.body)
        expect(result["id"]).to eq(batch.id)
        expect(result["name"]).to eq(batch.name)
        expect(result["course"]["id"]).to eq(course.id)
      end
    end
  end

  describe "DELETE /DESTROY" do
    context "delete request" do
      it "should not delete school when request is called by student" do
        school
        sign_in(student)
        course = create(:course, school_id: school.id)
        batch = create(:batch, course_id: course.id)
        delete "/batches/#{batch.id}.json", params: {course_id: course.id}

        result = JSON.parse(response.body)
        expect(result["data"]).to eq([])
        expect(result["error"]).to eq("You are not authorize user")
      end

      it "should delete school when request is called by admin" do
        school
        sign_in(school_admin)
        course = create(:course, school_id: school.id)
        batch = create(:batch, course_id: course.id)
        delete "/batches/#{batch.id}.json", params: {course_id: course.id}

        result = JSON.parse(response.body)
        expect(result["data"]).to eq([])
        expect(result["message"]).to eq("Batch was successfully destroyed.")
      end
    end
  end
end
