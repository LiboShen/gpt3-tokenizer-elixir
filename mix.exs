defmodule Gpt3Tokenizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :gpt3_tokenizer,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
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
      {:jason, "~> 1.2"},
      {:memoize, "~> 1.4"}
    ]
  end
end
