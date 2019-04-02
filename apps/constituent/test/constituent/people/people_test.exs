defmodule Constituent.PeopleTest do
  use Constituent.DataCase

  alias Constituent.People

  describe "persons" do
    alias Constituent.People.Person

    @valid_attrs %{biography: "some biography", date_of_birth: "2010-04-17 14:00:00.000000Z", name: "some name", national_identity: "some national_identity", short_biography: "some short_biography"}
    @update_attrs %{biography: "some updated biography", date_of_birth: "2011-05-18 15:01:01.000000Z", name: "some updated name", national_identity: "some updated national_identity", short_biography: "some updated short_biography"}
    @invalid_attrs %{biography: nil, date_of_birth: nil, name: nil, national_identity: nil, short_biography: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_person()

      person
    end

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert People.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert People.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = People.create_person(@valid_attrs)
      assert person.biography == "some biography"
      assert person.date_of_birth == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert person.name == "some name"
      assert person.national_identity == "some national_identity"
      assert person.short_biography == "some short_biography"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, person} = People.update_person(person, @update_attrs)
      assert %Person{} = person
      assert person.biography == "some updated biography"
      assert person.date_of_birth == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert person.name == "some updated name"
      assert person.national_identity == "some updated national_identity"
      assert person.short_biography == "some updated short_biography"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_person(person, @invalid_attrs)
      assert person == People.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = People.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> People.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = People.change_person(person)
    end
  end
end
