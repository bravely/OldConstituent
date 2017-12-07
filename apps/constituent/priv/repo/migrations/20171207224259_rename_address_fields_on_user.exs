defmodule Constituent.Repo.Migrations.RenameAddressFieldsOnUser do
  use Ecto.Migration

  def change do
    rename table(:users), :address_1, to: :address_one
    rename table(:users), :address_2, to: :address_two
  end
end
