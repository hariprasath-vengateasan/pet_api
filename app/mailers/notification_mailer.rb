class NotificationMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def vaccination_expired(pet)
    @pet = pet
    mail(
      to: "inbox@example.com",
      subject: "Vaccination expired for #{@pet.name}"
    )
  end
end
