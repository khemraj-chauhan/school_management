require 'rails_helper'

RSpec.describe User, type: :model do
  let(:stubbed_user) { build_stubbed(:user) }

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
    user
  end

  let(:school_admin) do
    user = create(:user)
    role = create(:role, name: "school_admin")
    user_role = create(:user_role, user_id: user.id, role_id: role.id)
    user
  end

  describe '#User model attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:phone).of_type(:string) }
  end

  describe '#active_record validations' do
    context '#name' do
      it { expect(stubbed_user).to validate_presence_of(:name) }
    end

    context '#email' do
      it { expect(stubbed_user).to validate_presence_of(:email) }
    end

    context '#phone' do
      it { expect(stubbed_user).to validate_presence_of(:phone) }
    end
  end

  describe '#User has_many active_record associations' do
    it { should have_many(:user_roles).dependent(:destroy) }
    it { should have_many(:roles).through(:user_roles) }
    it { should have_many(:school_admins).dependent(:destroy).with_foreign_key(:admin_id) }
    it { should have_many(:schools).through(:school_admins) }
    it { should have_many(:courses).through(:schools) }
    it { should have_many(:student_batches).dependent(:destroy).with_foreign_key(:student_id) }
    it { should have_many(:approved_student_batches).dependent(:destroy).with_foreign_key(:student_id) }
    it { should have_many(:batches).through(:student_batches) }
    it { should have_many(:stundent_courses).through(:batches) }
    it { should have_many(:stundent_schools).through(:stundent_courses) }
  end

  describe '#User has_one active_record associations' do
    it { should have_one(:address).dependent(:destroy) }
  end

  describe "When users have roles" do
    context '#has_role?' do
      it "return ture if same role found" do
        expect(admin.has_role?("admin")).to be_truthy
      end

      it "return false if other than admin role check" do
        expect(admin.has_role?("school_admin")).to be_falsy
        expect(admin.has_role?("student")).to be_falsy
      end
    end

    context '#has_any_role?' do
      it "return ture if any role matched" do
        expect(admin.has_any_role?(["admin", "student"])).to be_truthy
      end

      it "return false if no role matched" do
        expect(admin.has_any_role?(["school_admin", "student"])).to be_falsy
        expect(admin.has_any_role?(["student"])).to be_falsy
      end
    end

    context '#admin?' do
      it "return ture if user role is admin" do
        expect(admin.admin?).to be_truthy
      end

      it "return false if user role is not admin" do
        expect(student.admin?).to be_falsy
      end
    end

    context '#school_admin?' do
      it "return ture if user role is school_admin" do
        expect(school_admin.school_admin?).to be_truthy
      end

      it "return false if user role is not school_admin" do
        expect(admin.school_admin?).to be_falsy
        expect(student.school_admin?).to be_falsy
      end
    end

    context '#student?' do
      it "return ture if user role is student" do
        expect(student.student?).to be_truthy
      end

      it "return false if user role is not student" do
        expect(student.admin?).to be_falsy
        expect(student.school_admin?).to be_falsy
      end
    end

    context '#any_admin?' do
      it "return ture if user role is any kind of admin" do
        expect(admin.any_admin?).to be_truthy
        expect(school_admin.any_admin?).to be_truthy
      end

      it "return false if user role is not admin" do
        expect(student.any_admin?).to be_falsy
        expect(student.any_admin?).to be_falsy
      end
    end
  end
end
