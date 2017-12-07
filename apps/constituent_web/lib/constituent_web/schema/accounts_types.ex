defmodule ConstituentWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  alias ConstituentWeb.Resolvers
  alias ConstituentWeb.Schema.Middleware

  object :user do
    field :id, :id
    field :email, :string
    field :username, :string
    field :address_one, :string
    field :address_two, :string
    field :city, :string
    field :state, :string
    field :zip, :string
  end

  object :login do
    field :access_token, :string
    field :refresh_token, :string
  end

  object :account_queries do
    @desc "User information for logged-in user"
    field :me, type: :user do
      resolve &Resolvers.Accounts.me/3
    end
  end

  object :account_mutations do
    @desc "Create a new account"
    field :register_user, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :username, non_null(:string)
      arg :address_one, non_null(:string)
      arg :address_two, :string
      arg :city, non_null(:string)
      arg :state, non_null(:string)
      arg :zip, non_null(:string)

      resolve &Resolvers.Accounts.register_user/3
      middleware Middleware.ChangesetErrors
    end

    @desc "Create an access token and refresh token"
    field :create_token, type: :login do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.Accounts.login_user/3
    end

    @desc "Exchange a refresh token for a new access token"
    field :exchange_refresh_token, type: :login do
      arg :refresh_token, non_null(:string)

      resolve &Resolvers.Accounts.exchange_refresh_token/3
    end
  end
end
