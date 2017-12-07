defmodule ConstituentWeb.Schema.AccountsTypesTest do
  use ConstituentWeb.ConnCase, async: true

  describe "register_user" do
    test "that it creates and returns a user with valid data" do
      query = """
      mutation CreateAccount(
        $email: String!,
        $password: String!,
        $username: String!,
        $addressOne: String!,
        $city: String!,
        $state: String!,
        $zip: String!,
      ) {
        registerUser(
          email: $email,
          password: $password,
          username: $username,
          addressOne: $addressOne,
          city: $city,
          state: $state,
          zip: $zip
        ) {
          id
          email
        }
      }
      """
      variables = %{
        email: "test@constituentapp.com",
        password: "password",
        username: "bravelie",
        addressOne: "501 W Franklin St",
        city: "Boise",
        state: "ID",
        zip: "83702"
      }

      %{"data" => %{"registerUser" => user}} = graphql_query(build_conn(), query: query, variables: variables)

      assert user["email"] == variables.email
      assert user["id"]
    end

    test "that it returns errors with invalid data" do
      query = """
      mutation CreateAccount(
        $email: String!,
        $password: String!,
        $username: String!,
        $addressOne: String!,
        $city: String!,
        $state: String!,
        $zip: String!,
      ) {
        registerUser(
          email: $email,
          password: $password,
          username: $username,
          addressOne: $addressOne,
          city: $city,
          state: $state,
          zip: $zip
        ) {
          id
          email
        }
      }
      """
      variables = %{
        email: "test@constituentapp.com",
        password: "pass",
        username: "bravelie",
        addressOne: "501 W Franklin St",
        city: "Boise",
        state: "ID",
        zip: "83702"
      }

      assert %{"errors" => [%{"key" => "password"}]} = graphql_query(build_conn(), query: query, variables: variables)
    end
  end

  describe "create_token" do
    setup do
      query = """
      mutation LoginUser(
        $email: String!,
        $password: String!
      ) {
        createToken(
          email: $email,
          password: $password
        ) {
          accessToken
          refreshToken
        }
      }
      """
      %{query: query, user: insert(:user)}
    end
    test "with valid credentials provides access token and refresh token", %{query: query, user: user} do
      variables = %{
        email: user.email,
        password: user.password
      }

      %{"data" => %{"createToken" => created_tokens}} = graphql_query(build_conn(), query: query, variables: variables)

      assert created_tokens["accessToken"]
      assert created_tokens["refreshToken"]
    end

    test "with invalid credentials it returns an error", %{query: query, user: user} do
      variables = %{
        email: user.email,
        password: "nope"
      }

      %{"errors" => [error]} = graphql_query(build_conn(), query: query, variables: variables)

      assert error["message"] == "Email/Password combination is incorrect"
    end
  end

  describe "exchange_refresh_token" do
    setup do
      query = """
      mutation ExchangeRefresh($refreshToken: String!) {
        exchangeRefreshToken(refreshToken: $refreshToken) {
          accessToken
          refreshToken
        }
      }
      """
      %{query: query, user: insert(:user)}
    end

    test "with valid refreshToken provides new access token", %{query: query, user: user} do
      {:ok, refresh_token, _claims} = ConstituentWeb.Guardian.encode_and_sign(user, %{}, token_type: "refresh")
      variables = %{refreshToken: refresh_token}

      %{"data" => %{"exchangeRefreshToken" => exchanged_tokens}} = graphql_query(build_conn(), query: query, variables: variables)

      assert exchanged_tokens["accessToken"]
      assert exchanged_tokens["refreshToken"] == refresh_token
    end

    test "with invalid refreshToken returns an error", %{query: query} do
      variables = %{refreshToken: "nope"}

      %{"errors" => [error]} = graphql_query(build_conn(), query: query, variables: variables)

      assert error["message"] == "Invalid refresh token"
    end
  end

  describe "me" do
    setup do
      query = """
      query {
        me {
          id
          email
          username
          addressOne
          city
          state
          zip
        }
      }
      """
      %{query: query, user: insert(:user)}
    end

    test "with valid login credentials it returns logged-in user's data", %{query: query, user: user} do
      %{"data" => %{"me" => my_data}} = authed_graphql_query(build_conn(), user, query: query)

      assert my_data["id"] == to_string(user.id)
      assert my_data["addressOne"] == user.address_one
    end

    test "with valid login credentials to a nonexistent user it errors", %{query: query} do
      deleted_user = %Constituent.Accounts.User{id: 99999999}
      %{"errors" => [error]} = authed_graphql_query(build_conn(), deleted_user, query: query)

      assert error["message"] == "User with id #{deleted_user.id} not found"
    end

    test "with no login credentials it returns an error", %{query: query} do
      %{"errors" => [error]} = graphql_query(build_conn(), query: query)

      assert error["message"] == "Must have Authorization header credentials to access"
    end
  end
end
