defmodule Researcher.OpenStates do
  use HTTPoison.Base

  def get_state(state_abbr) do
    get("metadata/" <> String.downcase(state_abbr) <> "/")
  end

  def get_districts_for_state(state_abbr, chamber \\ nil) do
    if chamber do
      "districts/#{String.downcase(state_abbr)}/#{chamber}/"
    else
      "districts/#{String.downcase(state_abbr)}/"
    end
    |> get
  end

  def get_representatives_for_state(state_abbr, chamber \\ nil) do
    if chamber do
      "legislators/?state=#{String.downcase(state_abbr)}&chamber=#{chamber}"
    else
      "legislators/?state=#{String.downcase(state_abbr)}"
    end
    |> get
  end

  def process_url(url) do
    "https://openstates.org/api/v1/" <> url
  end

  def process_request_headers(headers) do
    [{"X-API-KEY", System.get_env("OPEN_STATES_API_KEY")} | headers]
  end

  def process_response_body(body) do
    Jason.decode!(body)
  end
end
