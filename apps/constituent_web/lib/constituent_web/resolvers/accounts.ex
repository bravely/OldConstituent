defmodule ConstituentWeb.Resolvers.Accounts do
  alias Constituent.Accounts

  def list_users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_parent, args, _resolution) do
    args
    |> Accounts.create_user
  end

  def login_user(_parent, %{email: email, password: password}, _resolution) do
    case Accounts.find_user_by_login(email, password) do
      {:ok, user} ->
        {:ok, create_login(user)}
      {:error, _err} ->
        {:error, "Email/Password combination is incorrect"}
    end
  end

  defp create_login(user) do
    {:ok, access_token, _claims} = ConstituentWeb.Guardian.encode_and_sign(user)
    {:ok, refresh_token, _claims} = ConstituentWeb.Guardian.encode_and_sign(user, %{}, token_type: "refresh")

    %{
      access_token: access_token,
      refresh_token: refresh_token
    }
  end

  def exchange_refresh_token(_parent, %{refresh_token: refresh_token}, _resolution) do
    case ConstituentWeb.Guardian.exchange(refresh_token, "refresh", "access") do
      {:ok, _old, {access_token, _new_claims}} ->
        {:ok, %{access_token: access_token, refresh_token: refresh_token}}
      {:error, _reason} -> {:error, "Invalid refresh token"}
    end
  end

  def me(_parent, _args, %{context: %{auth_claims: auth_claims}}) do
    case Accounts.get_user(auth_claims.user_id) do
      nil -> {:error, "User with id #{auth_claims.user_id} not found"}
      me -> {:ok, me}
    end
  end
  def me(_parent, _args, _info), do: {:error, "Must have Authorization header credentials to access"}
end
