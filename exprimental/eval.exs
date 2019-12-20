defmodule Eval do
  def init({name, server_name}) do
    :global.register_name(String.to_atom(name), self())
    Node.connect(String.to_atom(server_name))
    :global.sync()
    server_pid = :global.whereis_name(:server)
    GenServer.call(server_pid, {:ready, name})
    {:ok, server_pid}
  end

  def start() do
    start_link("e2", "e1@127.0.0.1")
  end

  def start_link(name, server_name) do
    GenServer.start_link(__MODULE__, {name, server_name}, name: __MODULE__)
  end

  def handle_cast({:eval, code}, server_pid) do
    IO.puts("call eval : " <> code)
    asyncEvalWithTimeout(server_pid, code, 10_000)
    {:noreply, server_pid}
  end

  def asyncEvalWithTimeout(server_pid, code, timeout) do
    spawn(fn ->
      task = Task.async(fn -> eval(code) end)

      case Task.yield(task, timeout) || Task.shutdown(task) do
        {:ok, result} ->
          GenServer.call(server_pid, {:result, result})

        nil ->
          GenServer.call(server_pid, {:fail})
      end
    end)
  end

  def eval(code) do
    sanitized = String.replace(code, "System", "")

    [status, result] =
      try do
        {term, _} = Code.eval_string(sanitized)

        case term do
          nil -> ["empty", term]
          _ -> ["ok", Kernel.inspect(term)]
        end
      rescue
        e in _ ->
          ["error", Kernel.inspect(e)]
          # e in CompileError ->
          #   ["error", code, "line: #{e.line} : " <> e.description]
          # e in UndefinedFunctionError->
          #   ["error", code, "UndefinedFunctionError : " <> e.description]
          # e in _ ->
          #   ["error", code, "line: #{e.line} : " <> e.description]
      end

    {result, status}
  end
end

Eval.start()
