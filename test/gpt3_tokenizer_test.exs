defmodule Gpt3TokenizerTest do
  use ExUnit.Case
  doctest Gpt3Tokenizer

  test "greets the world" do
    assert Gpt3Tokenizer.hello() == :world
  end
end
