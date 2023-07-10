require 'rails_helper'

RSpec.describe "Schools", type: :request do
  let(:admin) do
    user = create(:user)
    role = create(:role, name: "admin")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    user
  end

  let(:student) do
    user = create(:user)
    role = create(:role, name: "student")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    course = create(:course, school_id: school.id)
    batch = create(:batch, course_id: course.id)
    student_batch = create(:student_batch, student_id: user.id, batch_id: batch.id)
    user
  end

  let(:school) { create(:school) }

  let(:school_admin) do
    user = create(:user)
    role = create(:role, name: "school_admin")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    create(:school_admin, school_id: school.id, admin_id: user.id)
    user
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:set_current_user).and_return(nil)
  end

  describe "GET /index" do
    context "should return the list of Schools" do
      it "when request is called by admin and no school created" do
        sign_in(admin)
        get "/schools.json"

        result = JSON.parse(response.body)
        expect(result).to eq([])
      end

      it "when request is called by admin and schools are present" do
        school
        sign_in(admin)
        get "/schools.json"

        result = JSON.parse(response.body)
        expect(result.count).to eq(1)
        expect(result[0]["id"]).to eq(school.id)
        expect(result[0]["address"]).to eq(school.address.full_address)
      end

      it "when request is called by school admin" do
        school
        sign_in(school_admin)
        get "/schools.json"

        result = JSON.parse(response.body)
        expect(result.count).to eq(1)
        expect(result[0]["id"]).to eq(school.id)
        expect(result[0]["address"]).to eq(school.address.full_address)
        expect(result[0]["school_admin"][0]["email"]).to eq(school_admin.email)
      end

      it "when request is called by school student" do
        school
        sign_in(student)
        get "/schools.json"

        result = JSON.parse(response.body)

        expect(result.count).to eq(1)
        expect(result[0]["id"]).to eq(school.id)
        expect(result[0]["address"]).to eq(school.address.full_address)
      end
    end
  end

  describe "POST /create" do
    context "should return newly created school" do
      it "when request is called by admin" do
        school_params = {
          "school": {
              "name": "IIT Delhi",
              "address_attributes": {
                  "location": "HSR Layout",
                  "city": "Delhi",
                  "state": "Delhi",
                  "pincode": "560102"
              },
              "user": {
                  "name": "Rekha School admin",
                  "email": "rekha@school.com",
                  "phone": "121212"
              }
          }
        }
        create(:role, name: "school_admin")
        sign_in(admin)
        expect(School.count).to eq(0)
        post "/schools.json", params: school_params

        result = JSON.parse(response.body)
        expect(School.count).to eq(1)
      end
    end
  end

  describe "GET /SHOW" do
    context "should return specific school details" do
      it "when request is called by admin or school admin" do
        school
        sign_in(school_admin)
        get "/schools/#{school.id}.json"

        result = JSON.parse(response.body)
        expect(result["id"]).to eq(school.id)
        expect(result["school_admin"][0]["id"]).to eq(school_admin.id)
      end
    end
  end

  describe "DELETE /DESTROY" do
    context "delete request" do
      it "should not delete school when request is called by school admin" do
        school
        sign_in(school_admin)
        delete "/schools/#{school.id}.json"

        result = JSON.parse(response.body)
        expect(result["data"]).to eq([])
        expect(result["error"]).to eq("You are not authorize user")
      end

      it "should delete school when request is called by admin" do
        school
        sign_in(admin)
        delete "/schools/#{school.id}.json"

        result = JSON.parse(response.body)
        expect(result["data"]).to eq([])
        expect(result["message"]).to eq("School was successfully destroyed.")
      end
    end
  end
end
