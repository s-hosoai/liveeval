defmodule LiveevalWeb.LivePage do
  use Phoenix.HTML
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <textarea phx-hook="MyHook" class="elixir-codeblock" name="code" value="<%= @code %>" placeholder="input elixir code."> </textarea>
    <div class="result-block <%= @status %>"><%= @result %></div>
    """
  end

  def handle_params(%{"id" => id}, _url, socket) do
    socket = assign(socket, id: id)
    {:noreply, socket}
  end

  def mount(_session, socket) do
    {:ok, assign(socket, code: "", result: "", status: "empty")}
  end

  def handle_event("change", %{"code" => code}, socket) do
    send(self(), {:submit, code})
    {:noreply, assign(socket, code: code)}
  end

  def handle_info({:submit, code}, socket) do
    cleansing = String.replace(code, "System", "")

    [status, result] =
      try do
        {term, _} = Code.eval_string(cleansing)

        case term do
          nil -> ["empty", term]
          _ -> ["ok", Kernel.inspect(term)]
        end
      rescue
        e in _ ->
          ["error", Kernel.inspect(e)]
      end

    {:noreply, assign(socket, result: result, status: status)}
  end
end
