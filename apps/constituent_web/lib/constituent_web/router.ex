defmodule ConstituentWeb.Router do
  use ConstituentWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ConstituentWeb.Auth.AccessPipeline
  end

  scope "/", ConstituentWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: ConstituentWeb.Schema

    forward "/", Absinthe.Plug, schema: ConstituentWeb.Schema
  end
end
