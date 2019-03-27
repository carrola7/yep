Fabricator(:review) do
  rating { [1, 2, 3, 4, 5].sample }
  body { Faker::Lorem.paragraphs }
end