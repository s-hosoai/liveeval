defmodule Client do
  use GenServer

  def init({name, server_name}) do
    :global.register_name(String.to_atom(name), self())
    Node.connect(String.to_atom(server_name))
    :global.sync()
    server_pid = :global.whereis_name(:server)
    GenServer.call(server_pid, {:ready, name})
    {:ok, server_pid}
  end

  def start_link(name, server_name) do
    GenServer.start_link(__MODULE__, {name, server_name}, name: __MODULE__)
  end

  def handle_cast(:hello, server_pid) do
    IO.puts("Hello, I'm client")
    GenServer.call(server_pid, {:hello, "client"})
    {:noreply, server_pid}
  end
end

Client.start_link("client", "server@host.docker.internal")
