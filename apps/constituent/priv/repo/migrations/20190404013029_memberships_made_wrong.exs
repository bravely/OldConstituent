defmodule Constituent.Repo.Migrations.MembershipsMadeWrong do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      remove :area_id, references(:areas, on_delete: :nothing)
      add :person_id, references(:persons, on_delete: :nothing)
    end
  end
end
