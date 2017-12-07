defmodule ConstituentWeb.Plugs.Context do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    put_private(conn, :absinthe, %{context: build_context(conn)})
  end

  defp build_context(conn) do
    case Guardian.Plug.current_claims(conn) do
      %{"sub" => user_id} ->
        %{auth_claims: %{user_id: user_id}}
      nil -> nil
    end
  end
end
