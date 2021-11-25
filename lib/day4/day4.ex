defmodule Aoc.Day4 do
  @type secret_key :: String.t()
  @type trailing_number :: number()
  @type matcher :: String.t()

  @spec part_1(secret_key()) :: number()
  def part_1(secret_key) do
    hash(secret_key, 0, "00000")
  end

  @spec part_2(secret_key()) :: number()
  def part_2(secret_key) do
    hash(secret_key, 0, "000000")
  end

  @spec hash(secret_key(), trailing_number(), matcher()) :: number()
  def hash(secret_key, trailing_number, matcher) do
    :crypto.hash(:md5, "#{secret_key}#{trailing_number}")
    |> Base.encode16()
    |> String.starts_with?(matcher)
    |> if do
      trailing_number
    else
      hash(secret_key, trailing_number + 1, matcher)
    end
  end
end
