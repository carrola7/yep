Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  city { Faker::Address.city }
  country { Faker::Address.country }
  loves { Faker::Lorem.paragraph }
  birthday_d { Faker::Number.between(1, 31) }
  birthday_m { Date::MONTHNAMES[Faker::Number.between(1, 12)] }
  birthday_y { Faker::Number.between(1901, 2020) }
end