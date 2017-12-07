defmodule ConstituentWeb.Auth.AccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :constituent_web

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug ConstituentWeb.Plugs.Context
end
