defmodule Constituent.Factory do
  use ExMachina.Ecto, repo: Constituent.Repo
  use Constituent.UserFactory
end