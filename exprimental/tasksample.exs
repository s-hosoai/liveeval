defmodule Promise do
  def then(func, resolve, reject, timeout) do
    spawn(fn ->
      task = Task.async(func)

      case Task.yield(task, timeout) || Task.shutdown(task) do
        {:ok, result} ->
          resolve.(result)

        nil ->
          reject.()
      end
    end)
  end
end

defmodule MyAsyncProc do
  def start(func, success, fail, timeout) do
    spawn(fn ->
      task = Task.async(func)

      case Task.yield(task, timeout) || Task.shutdown(task) do
        {:ok, result} ->
          success.(result)

        nil ->
          fail.()
      end
    end)
  end

  def start(f) do
    start(f, &success/1, &fail/0, 500)
  end

  def success(result) do
    IO.puts("success" <> result)
  end

  def fail() do
    IO.puts("fail")
  end
end

f = fn ->
  Process.sleep(300)
  IO.puts("func end")
  "RESULT "
end

MyAsyncProc.start(f)
IO.puts("start task")
Process.sleep(1000)
