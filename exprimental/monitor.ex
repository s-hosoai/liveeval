defmodule Monitor do
  use GenServer

  def init(init) do
    :global.register_name(:server, self())
    {:ok, init}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call({:ready, client_name}, _from, state) do
    :global.sync()
    client_pid = :global.whereis_name(String.to_atom(client_name))
    call_eval(client_pid)
    {:reply, client_pid, state}
  end

  def handle_call({:result, result}, _from, state) do
    IO.inspect(result)
    {:reply, [], state}
  end

  def handle_call(:fail, _from, state) do
    IO.puts("fail")
    {:reply, [], state}
  end

  def call_eval(client_pid) do
    GenServer.cast(client_pid, {:eval, "[1,2,3]"})
  end
end

Monitor.start_link()
