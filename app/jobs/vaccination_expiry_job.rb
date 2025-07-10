class VaccinationExpiryJob < ActiveJob::Base
  queue_as :default
  def perform(pet_id)
    pet = Pet.find_by(id: pet_id)
    return unless pet
    Rails.logger.info "[SIMULATION] Vaccination expired for Pet: #{pet.name} (ID: #{pet.id})"

    # Enqueue simulated email
    NotificationMailer.vaccination_expired(pet).deliver_later
  end
end
