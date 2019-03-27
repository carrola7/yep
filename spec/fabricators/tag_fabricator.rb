Fabricator(:tag) do
  name { Faker::Lorem.unique.word }
end