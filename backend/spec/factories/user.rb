FactoryBot.define do
  factory :user do
    to_create do |user|
      user.id = DB[:users].insert(**user.attributes)
    end

    sequence :id do |n|
      n
    end

    email { 'some-email@example.com' }
    password { '12345678' }
    token { 'some-token' }

    initialize_with do
      params = {
        id: id,
        email: email,
        password: password,
        token: token
      }
      new(params)
    end
  end
end
