defmodule ChineseTranslationServerBench do
  use Benchfella

  defp get_socket do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 4040, opts)
    socket
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end

  @simp "长大以后变成长工"
  @trad "長大以後變成長工"
  @pinyin ChineseTranslation.pinyin(@simp)
  @slug ChineseTranslation.slugify(@simp)
  @slug1 ChineseTranslation.slugify(@simp, [:tone])

  bench "translate to simplified", [socket: get_socket] do
    send_and_recv(socket, "SIMP #{@trad}\r\n")
  end

  bench "translate to traditional", [socket: get_socket] do
    send_and_recv(socket, "TRAD #{@simp}\r\n")
  end

  bench "chinese to pinyin", [socket: get_socket] do
    send_and_recv(socket, "PINYIN #{@simp}\r\n")
  end

  bench "chinese to slug", [socket: get_socket] do
    send_and_recv(socket, "SLUG #{@simp}\r\n")
  end

  bench "chinese to slug with tone", [socket: get_socket] do
    send_and_recv(socket, "SLUG1 #{@simp}\r\n")
  end
end
