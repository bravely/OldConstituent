defmodule Constituent do
  @moduledoc """
  Constituent keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def data_handling do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      alias Constituent.Support # To provide Support.Ecto methods
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
