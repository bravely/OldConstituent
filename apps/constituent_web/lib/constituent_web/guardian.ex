defmodule ConstituentWeb.Guardian do
  use Guardian, otp_app: :constituent_web

  alias Constituent.Accounts

  def subject_for_token(%Accounts.User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :improper_resource_type}
  end

  def resource_from_claims(%{"sub" => sub}) do
    {:ok, sub |> String.to_integer |> Accounts.get_user!}
  end

  def resource_from_claims(_claims) do
    {:error, :claims_do_not_include_subject}
  end
end
