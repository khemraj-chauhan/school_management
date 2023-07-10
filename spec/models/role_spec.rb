require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:stubbed_role) { build_stubbed(:role) }

  describe '#Role model attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe '#active_record validations' do
    context '#name' do
      it { expect(stubbed_role).to validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name)}
    end
  end

  describe '#User has_many active_record associations' do
    it { should have_many(:user_roles).dependent(:destroy) }
    it { should have_many(:users).through(:user_roles) }
  end
end
