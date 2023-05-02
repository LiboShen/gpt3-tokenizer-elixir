defmodule Gpt3TokenizerTest do
  use ExUnit.Case
  doctest Gpt3Tokenizer
  import Gpt3Tokenizer

  test "works with empty string" do
    assert encode("") == []
    assert token_count("") == 0
  end

  test "works with a single space" do
    assert encode(" ") == [220]
    assert token_count(" ") == 1
    assert " " |> encode |> decode == " "
  end

  test "works with simple text" do
    text = "hello world"
    assert encode(text) == [31373, 995]
    assert token_count(text) == 2
    assert text |> encode |> decode == text
  end

  test "works with multi-token_word" do
    text = "indivisible"
    assert encode(text) == [521, 452, 12843]
    assert token_count(text) == 3
    assert text |> encode |> decode == text
  end

  test "works with emojis" do
    text = "hello 👋 world 🌍"
    assert encode(text) == [31373, 50169, 233, 995, 12520, 234, 235]
    assert token_count(text) == 7
    assert text |> encode |> decode == text
  end
end
