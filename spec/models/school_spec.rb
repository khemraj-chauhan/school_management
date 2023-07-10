require 'rails_helper'

RSpec.describe School, type: :model do
  let(:stubbed_school) { build_stubbed(:school) }

  describe '#School model attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe '#active_record validations' do
    context '#name' do
      it { expect(stubbed_school).to validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name)}
    end
  end

  describe '#School has_one active_record associations' do
    it { should have_one(:address).dependent(:destroy) }
  end

  describe '#School has_many active_record associations' do
    it { should have_many(:school_admins).dependent(:destroy) }
    it { should have_many(:admins).through(:school_admins) }
    it { should have_many(:courses).dependent(:destroy) }
  end
end
