FactoryBot.define do
  factory :order do
    no {Faker::PhoneNumber.cell_phone}
    state {'first'}
  end
end
