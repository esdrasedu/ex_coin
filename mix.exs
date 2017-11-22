defmodule ExCoin.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_coin,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:exleveldb, "~> 0.12.1"},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:credo, "~> 0.8.1", only: [:dev, :test], runtime: false}
    ]
  end
end
