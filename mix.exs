defmodule Gpt3Tokenizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :gpt3_tokenizer,
      version: "0.1.0",
      elixir: "~> 1.0",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/LiboShen/gpt3-tokenizer-elixir",
      description: description(),
      package: package(),
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
      {:jason, "~> 1.4"},
      {:memoize, "~> 1.4.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

defp description() do
    """
    OpenAI GPT-3 Tokenizer
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/LiboShen/gpt3-tokenizer-elixir"}
    ]
  end
end
