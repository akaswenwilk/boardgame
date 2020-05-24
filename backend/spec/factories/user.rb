FactoryBot.define do
  factory :user do
    skip_create

    sequence :id do |n|
      n
    end

    email { 'some-email@example.com' }
    password { '12345678' }

    initialize_with do
      params = {
        id: id,
        email: email,
        password: password
      }
      new(params)
    end
  end
end
