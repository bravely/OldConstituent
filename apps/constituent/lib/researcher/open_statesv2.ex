defmodule OpenStatesv2 do
  def query(query, variables \\ %{}, options \\ []) do
    opts = Keyword.merge(default_config(), options)
    Neuron.query(query, variables, opts)
  end

  def default_config do
    [
      url: "https://openstates.org/graphql",
      headers: ["X-API-KEY", System.get_env("OPEN_STATES_API_KEY")]
    ]
  end
end
