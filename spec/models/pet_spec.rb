require 'rails_helper'

RSpec.describe Pet, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:breed) }
  it { should validate_numericality_of(:age).only_integer.is_greater_than_or_equal_to(0) }
end
