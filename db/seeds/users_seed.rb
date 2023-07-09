# frozen_string_literal: true

# Create a main sample user.
FactoryBot.create(:user,
                  first_name: 'Melon',
                  last_name: 'Musk',
                  email: 'admin@melon.com',
                  password: 'Truemelon@123',
                  password_confirmation: 'Truemelon@123',
                  role: 'admin'
                 )

# Create a second sample user.
FactoryBot.create(:user,
                  first_name: 'Jack',
                  last_name: 'Ma',
                  email: 'admin@jack.com',
                  password: 'Truejack@123',
                  password_confirmation: 'Truejack@123',
                  role: 'admin'
                 )
