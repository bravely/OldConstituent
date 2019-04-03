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
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
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
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Postgres Adapter
      {:postgrex, ">= 0.0.0"},
      # DB Layer
      {:ecto_sql, "~> 3.0"},
      # Password Hashing
      {:comeonin, "~> 4.0"},
      # Better Password Hashing
      {:argon2_elixir, "~> 1.2"},
      # Easier Downloads
      {:download,
       git: "git://github.com/bravely/download.git", branch: "fix-process-communication"},
      # Easy parallel pipelines
      {:flow, "~> 0.12"},
      # Shapefile Handler
      {:exshape, "~> 2.0.10"},
      # PostGIS Functions
      {:geo, "~> 3.1"},
      # PostGIS Adapter
      {:geo_postgis, "~> 3.1"},
      # .shp read and conversion
      {:shape_shift, path: "/Users/pepyri/dev/shape_shift"},
      {:mock, "~> 0.3"},
      {:ex_machina, "~> 2.3"},
      {:faker, "~> 0.9"},
      {:httpoison, "~> 1.0", override: true},
      {:neuron, "~> 1.1"}
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
