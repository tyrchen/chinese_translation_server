defmodule ChineseTranslationServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:tcp_server, :port)
    children = [
      supervisor(Task.Supervisor, [[name: ChineseTranslationServer.TaskSupervisor]]),
      worker(Task, [ChineseTranslationServer, :accept, [port]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChineseTranslationServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def accept(port) do
    # `:binary` - receives data as binaries instead of lists
    # `packet: :line` - receives data line by line
    # `active: false` - block on `:gen_tcp.recv/2` until data is available
    {:ok, socket} = :gen_tcp.listen(port,
                    [:binary, packet: :line, active: false])
    IO.puts "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child ChineseTranslationServer.TaskSupervisor, fn -> serve(client) end
    loop_acceptor(socket)
  end

  defp serve(socket) do
    import Pipe

    msg =
      pipe_matching x, {:ok, x}, read_line(socket)
        |> TcpServer.Command.parse()
        |> TcpServer.Command.run()

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, msg) do
    :gen_tcp.send(socket, format_msg(msg))
  end

  defp format_msg({:ok, text}), do: text
  defp format_msg({:error, :unknown_command}), do: "UNKNOWN COMMAND\r\n"
  defp format_msg({:error, _}), do: "ERROR\r\n"
end
