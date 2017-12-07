defmodule ConstituentWeb.Schema do
  use Absinthe.Schema
  import_types ConstituentWeb.Schema.AccountsTypes

  query do
    import_fields :account_queries
  end

  mutation do
    import_fields :account_mutations
  end
end
