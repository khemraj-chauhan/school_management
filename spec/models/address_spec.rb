require 'rails_helper'
RSpec.describe Address, type: :model do
  let(:stubbed_address) { build_stubbed(:address) }

  describe '#Address model attributes' do
    it { is_expected.to have_db_column(:location).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:state).of_type(:string) }
    it { is_expected.to have_db_column(:pincode).of_type(:string) }
    it { is_expected.to have_db_column(:addressable_type).of_type(:string) }
    it { is_expected.to have_db_column(:addressable_id).of_type(:integer) }
  end

  describe '#active_record validations' do
    context '#location' do
      it { expect(stubbed_address).to validate_presence_of(:location) }
    end

    context '#city' do
      it { expect(stubbed_address).to validate_presence_of(:city) }
    end

    context '#state' do
      it { expect(stubbed_address).to validate_presence_of(:state) }
    end

    context '#pincode' do
      it { expect(stubbed_address).to validate_presence_of(:pincode) }
    end
  end

  describe '#Address belong_to active_record associations' do
    it { expect(stubbed_address).to belong_to(:addressable) }
  end

  describe "Fetch full address" do
    context '#full_address' do
      it "return complete address" do
        result = [stubbed_address.location, stubbed_address.city, stubbed_address.state, stubbed_address.pincode].reject(&:blank?).join(",").humanize
        expect(stubbed_address.full_address).to eq(result)
      end
    end
  end
end
