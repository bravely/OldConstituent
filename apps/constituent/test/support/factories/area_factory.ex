defmodule Constituent.AreaFactory do
  defmacro __using__(_opts) do
    quote do
      def area_factory do
        %Constituent.PoliticalEntities.Area{
          name: "Idaho",
          identifier: "ID",
          classification: "US State",
          codes: %{
            "USPS" => "ID",
            "FIPS" => 16,
            "region" => 4,
            "division" => 8
          }
        }
      end
    end
  end
end
