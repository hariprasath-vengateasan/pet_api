require "rails_helper"

RSpec.describe "Pets API", type: :request do
  let(:valid_attributes) { {name: "Fido", breed: "Beagle", age: 3} }

  describe "GET /pets" do
    before { Pet.create!(valid_attributes) }

    it "returns all pets" do
      get "/pets"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "GET /pets/:id" do
    let(:pet) { Pet.create!(valid_attributes) }

    it "returns the pet" do
      get "/pets/#{pet.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(pet.id)
    end
  end

  describe "POST /pets" do
    context "valid" do
      it "creates a pet" do
        expect { post "/pets", params: {pet: valid_attributes} }.to change(Pet, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid" do
      it "returns errors" do
        post "/pets", params: {pet: {name: "", breed: "", age: -1}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /pets/:id" do
    let(:pet) { Pet.create!(valid_attributes) }
    it "updates the pet" do
      put "/pets/#{pet.id}", params: {pet: {age: 5}}
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["age"]).to eq(5)
    end
  end

  describe "PATCH /pets/:id/expire_vaccination" do
    let(:pet) { Pet.create!(valid_attributes) }

    it "expires vaccination and enqueues job" do
      expect { patch "/pets/#{pet.id}/expire_vaccination" }.to change { Pet.find(pet.id).vaccinated }.from(true).to(false)
      expect(response).to have_http_status(:ok)
    end
  end
end
