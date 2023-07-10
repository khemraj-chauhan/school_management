require 'rails_helper'

RSpec.describe SchoolAdmin, type: :model do
  let(:stubbed_school_admin) { build_stubbed(:school_admin, school: build(:school), admin: build(:user)) }

  describe '#SchoolAdmin model attributes' do
    it { is_expected.to have_db_column(:school_id).of_type(:integer) }
    it { is_expected.to have_db_column(:admin_id).of_type(:integer) }
  end

  describe '#SchoolAdmin belong_to active_record associations' do
    it { expect(stubbed_school_admin).to belong_to(:school) }
    it { expect(stubbed_school_admin).to belong_to(:admin) }
  end
end
