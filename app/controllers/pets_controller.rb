class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :update, :expire_vaccination]

  def index
    pets = Pet.all
    render json: pets, status: :ok
  end

  def show
    render json: @pet, status: :ok
  end

  def create
    pet = Pet.new(pet_params)

    if pet.save
      render json: pet, status: :created
    else
      render json: {errors: pet.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @pet.update(pet_params)
      render json: @pet, status: :ok
    else
      render json: {errors: @pet.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def expire_vaccination
    @pet.expire_vaccination!
    render json: @pet, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Pet not found"}, status: :not_found
  end

  def pet_params
    params.require(:pet).permit(:name, :breed, :age)
  end
end
