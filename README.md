# Gpt3Tokenizer

BPE Encoder Decoder for GPT-3 implemented in native Elixir.

## Installation

The package can be installed
by adding `gpt3_tokenizer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gpt3_tokenizer, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
Gpt3Tokenizer.encode("hello 👋 world 🌍")
Gpt3Tokenizer.decode([31373, 50169, 233, 995, 12520, 234, 235])
Gpt3Tokenizer.token_count("This sentence is 6 tokens long")
```

## Reference

- [OpenAI official online tokenizer](https://platform.openai.com/tokenizer?view=bpe)
- [gpt-3-encoder](https://github.com/latitudegames/GPT-3-Encoder)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/gpt3_tokenizer>.

