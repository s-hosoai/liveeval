defmodule Server do
  use GenServer

  def init(init) do
    :global.register_name(:server, self())
    spawn(fn -> System.cmd("docker", ["run", "client"]) end)
    {:ok, init}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call({:ready, client_name}, _from, _state) do
    :global.sync()
    client_pid = :global.whereis_name(String.to_atom(client_name))
    IO.puts(client_name <> " is ready")
    GenServer.cast(client_pid, :hello)
    {:reply, client_pid, client_pid}
  end

  def handle_call({:hello, name}, _from, client_pid) do
    IO.puts("Hello " <> name <> ", I'm server")
    {:reply, client_pid, client_pid}
  end
end

Server.start_link()
