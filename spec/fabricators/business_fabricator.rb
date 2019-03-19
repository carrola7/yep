Fabricator(:business) do
  name { Faker::Company.name }
  address_1 { Faker::Address.street_address }
  address_2 { Faker::Address.community }
  city { Faker::Address.city }
  country { Faker::Address.country }
  phone { Faker::PhoneNumber.phone_number }
  price { [1, 2, 3, 4].sample }
end