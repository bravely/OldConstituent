defmodule ConstituentWeb.Schema.Middleware.ChangesetErrors do
  @behaviour Absinthe.Middleware

  alias ConstituentWeb.ErrorHelpers

  def call(%{errors: [error]} = res, _) when is_binary(error), do: res
  def call(res, _) do
    errors = Enum.flat_map(res.errors, fn
      %Ecto.Changeset{} = changeset -> transform_errors(changeset)
      error -> error
    end)
    %{res | errors: errors}
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&ErrorHelpers.translate_error/1)
    |> Enum.map(fn {key, value} ->
      %{key: key, message: value}
    end)
  end
end
