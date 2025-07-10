require "rails_helper"

RSpec.describe "Pets API", type: :request do
  let(:valid_attributes) { attributes_for(:pet) }
  let!(:existing_pet) { FactoryBot.create(:pet) }

  describe "GET /pets" do
    it "returns all pets" do
      get "/pets"
      expect(JSON.parse(response.body).size).to eq(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /pets/:id" do
    it "returns the pet" do
      get "/pets/#{existing_pet.id}"
      puts "existing_pet.id => #{response.body}"
      expect(JSON.parse(response.body)["id"]).to eq(existing_pet.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /pets" do
    context "with valid attributes" do
      it "creates a pet" do
        expect {
          post "/pets", params: {pet: valid_attributes}
        }.to change(Pet, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        post "/pets", params: {pet: {name: "", breed: "", age: -1}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /pets/:id" do
    it "updates the pet" do
      put "/pets/#{existing_pet.id}", params: {pet: {age: 5}}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["age"]).to eq(5)
    end
  end

  describe "PATCH /pets/:id/expire_vaccination" do
    it "expires vaccination and enqueues job" do
      expect {
        patch "/pets/#{existing_pet.id}/expire_vaccination"
      }.to change { Pet.find(existing_pet.id).reload.vaccinated }.from(true).to(false)
      expect(response).to have_http_status(:ok)
    end
  end
end
