defmodule ChineseTranslationServerTest do
  use ExUnit.Case

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 4041, opts)
    {:ok, socket: socket}
  end

  test "should return unknown command", %{socket: socket} do
    assert send_and_recv(socket, "UNKNOWN 中国人\r\n") ==
            "UNKNOWN COMMAND\r\n"
  end

  test "should return traditional chinese", %{socket: socket} do
    assert send_and_recv(socket, "TRAD 中国人\r\n") ==
            "中國人\r\n"
  end

  test "should return simplified chinese", %{socket: socket} do
    assert send_and_recv(socket, "SIMP 中國人\r\n") ==
            "中国人\r\n"
  end

  test "should return pinyin", %{socket: socket} do
    assert send_and_recv(socket, "PINYIN 中国人\r\n") ==
            "zhōng guó rén\r\n"
  end

  test "should return pinyin with traditional chinese", %{socket: socket} do
    assert send_and_recv(socket, "PINYIN 中國人\r\n") ==
            "zhōng guó rén\r\n"
  end

  test "should return slug", %{socket: socket} do
    assert send_and_recv(socket, "SLUG 中国人\r\n") ==
            "zhong-guo-ren\r\n"
  end

  test "should return slug with traditiona chinese", %{socket: socket} do
    assert send_and_recv(socket, "SLUG 中國人\r\n") ==
            "zhong-guo-ren\r\n"
  end

  test "should return slug with tone", %{socket: socket} do
    assert send_and_recv(socket, "SLUG1 中国人\r\n") ==
            "zhong1-guo2-ren2\r\n"
  end

  test "should return slug with tone for trad chinese", %{socket: socket} do
    assert send_and_recv(socket, "SLUG1 中國人\r\n") ==
            "zhong1-guo2-ren2\r\n"
  end

  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
