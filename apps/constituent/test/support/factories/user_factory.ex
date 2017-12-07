defmodule Constituent.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Constituent.Accounts.User{
          email: Faker.Internet.email(),
          username: Faker.Internet.user_name(),
          address_one: Faker.Address.street_address(),
          city: Faker.Address.city(),
          state: Faker.Address.state_abbr(),
          zip: Faker.Address.zip_code(),
          password: "password",
          password_hash: Comeonin.Argon2.hashpwsalt("password")
        }
      end
    end
  end
end
