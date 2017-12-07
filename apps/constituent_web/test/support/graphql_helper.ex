defmodule ConstituentWeb.GraphqlHelper do
  use Phoenix.ConnTest
  # We need to set the default endpoint for ConnTest
  @endpoint ConstituentWeb.Endpoint

  def graphql_query(conn, options) do
    conn
    |> post("/api/graphql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  def authed_graphql_query(conn, user, options) do
    conn
    |> put_req_header("authorization", "Bearer #{access_token_for(user)}")
    |> post("/api/graphql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  defp build_query(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
  end

  defp access_token_for(user) do
    {:ok, access_token, _claims} = ConstituentWeb.Guardian.encode_and_sign(user)

    access_token
  end
end
