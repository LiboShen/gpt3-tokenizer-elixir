defmodule Gpt3Tokenizer do
  @moduledoc """
  GPT-3 Tokenizer
  """

  use Memoize
  @encoder_file "lib/encoder.json"
  @bpe_file "lib/vocab.bpe"

  @bytes_to_unicode 0..256
                    |> Enum.reduce({[], 0}, fn x, {r, n} ->
                      if (?! <= x and x <= ?~) or (?¡ <= x and x <= ?¬) or
                           (?® <= x and x <= ?ÿ) do
                        {[{x, [x]} | r], n}
                      else
                        {[{x, [n + 256]} | r], n + 1}
                      end
                    end)
                    |> elem(0)
                    |> Enum.into(%{})

  @unicode_to_bytes @bytes_to_unicode
                    |> Enum.map(fn {k, v} -> {v, k} end)
                    |> Enum.into(%{})

  @encodings File.read!(@encoder_file)
             |> Jason.decode!()
             |> Map.new(fn {k, v} -> {k |> to_charlist(), v} end)
  @decodings @encodings |> Map.new(fn {k, v} -> {v, k} end)

  @bpe_data File.read!(@bpe_file)

  @bpe_pairs @bpe_data
             |> String.split("\n", trim: true)
             |> Enum.drop(1)
             |> Enum.map(&String.split(&1))
             |> Enum.map(fn [a, b] -> {a |> to_charlist(), b |> to_charlist()} end)

  @bpe_ranks Enum.zip(@bpe_pairs, 0..(length(@bpe_pairs) - 1)) |> Enum.into(%{})

  @doc """
  Count the number of tokens in a string.

  ## Examples

      iex> Gpt3Tokenizer.token_count("hello world")
      2
  """
  def token_count(text) do
    text
    |> apply_bpe()
    |> Enum.flat_map(fn x -> x end)
    # Skip encoder.json lookup for speed
    |> Enum.count()
  end

  @doc """
  Encode a string into a list of tokens.

  ## Examples

      iex> Gpt3Tokenizer.encode("hello world")
      [31373, 995]
  """
  def encode(text) do
    text
    |> apply_bpe()
    |> Enum.flat_map(fn x -> x end)
    |> Enum.map(fn token -> Map.get(@encodings, token) end)
  end

  @doc """
  Decode a list of tokens into a string.

  ## Examples

      iex> Gpt3Tokenizer.decode([31373, 995])
      "hello world"
  """
  def decode(tokens) do
    tokens
    |> Enum.map(fn token -> Map.get(@decodings, token) end)
    |> Enum.map(fn cl ->
      cl |> Enum.map(fn x -> @unicode_to_bytes[[x]] end) |> :erlang.list_to_binary()
    end)
    |> Enum.join()
  end

  defp apply_bpe(text) do
    tokens =
      Regex.scan(
        ~r/'s|'t|'re|'ve|'m|'ll|'d| ?\p{L}+| ?\p{N}+| ?[^\s\p{L}\p{N}]+|\s+(?!\S)|\s+/u,
        text
      )
      |> Enum.map(fn [token] ->
        token
        |> :binary.bin_to_list()
        |> Enum.map(fn x -> @bytes_to_unicode[x] end)
      end)

    Enum.map(tokens, &apply_bpe_to_token/1)
  end

  defmemop apply_bpe_to_token(word) do
    apply_bpe_to_token_recursive(word)
  end

  defp apply_bpe_to_token_recursive([word]) do
    [word]
  end

  defp apply_bpe_to_token_recursive(word) do
    pairs = get_pairs(word)
    min_pair = find_min_pair(pairs)
    break_pair = Map.get(@bpe_ranks, min_pair)

    case break_pair do
      nil -> word
      _ -> apply_bpe_to_token_recursive(merge_pair(word, min_pair))
    end
  end

  defp get_pairs(word) do
    Enum.zip(
      word |> Enum.slice(0..-2),
      word |> Enum.drop(1)
    )
  end

  defp find_min_pair(pairs) do
    pairs
    |> Enum.map(fn pair -> {Map.get(@bpe_ranks, pair) || 1.0e10, pair} end)
    |> Enum.min_by(fn {rank, _} -> rank end)
    |> elem(1)
  end

  defp merge_pair_recursive([a, b | rest], {first, second}, result)
       when a == first and b == second do
    merge_pair_recursive(rest, {first, second}, result ++ [first ++ second])
  end

  defp merge_pair_recursive([a | rest], {first, second}, result) do
    merge_pair_recursive(rest, {first, second}, result ++ [a])
  end

  defp merge_pair_recursive([], _, result) do
    result
  end

  defp merge_pair(word, {first, second}) do
    merge_pair_recursive(word, {first, second}, [])
  end
end
