require 'rails_helper'

RSpec.describe UserRole, type: :model do
  let(:stubbed_user_role) { build_stubbed(:user_role, role: build(:role), user: build(:user)) }

  describe '#UserRole model attributes' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:role_id).of_type(:integer) }
  end

  describe '#UserRole belong_to active_record associations' do
    it { expect(stubbed_user_role).to belong_to(:role) }
    it { expect(stubbed_user_role).to belong_to(:user) }
  end
end
