defmodule TcpServer.Command do
  @doc ~S"""
  Parse the given `line` into a command

  ## Examples

      iex> TcpServer.Command.parse "TRAD 中国人\r\n"
      {:ok, {:trad, "中国人"}}

      iex> TcpServer.Command.parse "SIMP 中國人\r\n"
      {:ok, {:simp, "中國人"}}

      iex> TcpServer.Command.parse "PINYIN 中国人\r\n"
      {:ok, {:pinyin, "中国人"}}

      iex> TcpServer.Command.parse "SLUG 中国人\r\n"
      {:ok, {:slug, "中国人"}}

      iex> TcpServer.Command.parse "SLUG1 中国人\r\n"
      {:ok, {:slug1, "中国人"}}

  Unknown commands or commands with the wrong number or arguments
  return an error:

      iex> TcpServer.Command.parse "UNKNOWN 中国人\r\n"
      {:error, :unknown_command}

  """
  def parse(line) do
    case String.split(line) do
      ["TRAD", data]   -> {:ok, {:trad, data}}
      ["SIMP", data]   -> {:ok, {:simp, data}}
      ["PINYIN", data] -> {:ok, {:pinyin, data}}
      ["SLUG", data]   -> {:ok, {:slug, data}}
      ["SLUG1", data]  -> {:ok, {:slug1, data}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Run the given command.
  """
  # TODO: tchen later to dispatch to different servers Mon Mar  9 21:40:30 2015
  def run(command)

  def run({:trad, data}) do
    ChineseTranslation.translate(data, :s2t)
    |> encapsulate
  end

  def run({:simp, data}) do
    ChineseTranslation.translate(data)
    |> encapsulate
  end

  def run({:pinyin, data}) do
    data
    |> ChineseTranslation.translate
    |> ChineseTranslation.pinyin
    |> encapsulate
  end

  def run({:slug, data}) do
    data
    |> ChineseTranslation.translate
    |> ChineseTranslation.slugify
    |> encapsulate
  end

  def run({:slug1, data}) do
    data
    |> ChineseTranslation.translate
    |> ChineseTranslation.slugify([:tone])
    |> encapsulate
  end

  defp encapsulate(value) do
    {:ok, "#{value}\r\nOK\r\n"}
  end
end
