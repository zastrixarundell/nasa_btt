defmodule NasaBtt.MixProject do
  use Mix.Project

  def project do
    [
      app: :nasa_btt,
      version: "0.1.0",
      elixir: "~> 1.16",
      deps: deps(),
      escript: [main_module: NasaBtt],
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NasaBtt.Application, []}
    ]
  end
  
  def releases do
    [
      nasa_btt_cli: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: :linux, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:burrito, github: "burrito-elixir/burrito"}
    ]
  end
end
