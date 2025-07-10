require "rails_helper"

RSpec.describe Pet, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:breed) }
  it { should validate_numericality_of(:age).only_integer.is_greater_than_or_equal_to(0) }

  # Default attribute
  it "defaults vaccinated to true" do
    pet = Pet.new
    expect(pet.vaccinated).to be true
  end

  describe "#expire_vaccination!" do
    let(:pet) { create(:pet, vaccinated: true) }

    it "sets vaccinated to false" do
      expect { pet.expire_vaccination! }.to change { pet.reload.vaccinated }.from(true).to(false)
    end

    it "enqueues a VaccinationExpiryJob" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        pet.expire_vaccination!
      }.to have_enqueued_job(VaccinationExpiryJob).with(pet.id)
    end
  end
end
