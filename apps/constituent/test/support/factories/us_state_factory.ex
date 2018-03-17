defmodule Constituent.UsStateFactory do
  defmacro __using__(_opts) do
    quote do
      def us_state_factory do
        %Constituent.PoliticalEntities.UsState{
          division: Enum.random(1..9),
          fips: Enum.random(1..79),
          name: Faker.Lorem.Shakespeare.king_richard_iii(),
          region: Enum.random(1..4),
          usps: Faker.String.base64(2),
        }
      end
    end
  end
end
