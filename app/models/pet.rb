class Pet < ApplicationRecord
  validates :name, presence: true
  validates :breed, presence: true
  validates :age, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}

  attribute :vaccinated, :boolean, default: true

  def expire_vaccination!
    update!(vaccinated: false)
    VaccinationExpiryJob.perform_later(id)
  end
end
