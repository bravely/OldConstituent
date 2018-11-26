defmodule Constituent.Mixfile do
  use Mix.Project

  def project do
    [
      app: :constituent,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Constituent.Application, []},
      extra_applications: [:logger, :runtime_tools, :ex_machina, :faker]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:postgrex, ">= 0.0.0"}, # Postgres Adapter
      {:ecto, "~> 2.1"}, # DB Layer
      {:comeonin, "~> 4.0"}, # Password Hashing
      {:argon2_elixir, "~> 1.2"}, # Better Password Hashing
      {:download, git: "git://github.com/bravely/download.git", branch: "fix-process-communication"}, # Easier Downloads
      {:flow, "~> 0.12"}, # Easy parallel pipelines
      {:exshape, "~> 2.0.10"}, # Shapefile Handler
      {:geo, "~> 2.0"}, # PostGIS Functions
      {:geo_postgis, "~> 1.0"}, # PostGIS Adapter
      {:shape_shift, path: "/Users/pepyri/dev/shape_shift"}, # .shp read and conversion
      {:mock, "~> 0.3"},
      {:ex_machina, "~> 2.1"},
      {:faker, "~> 0.9"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
