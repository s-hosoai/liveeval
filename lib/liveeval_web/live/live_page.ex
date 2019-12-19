defmodule LiveevalWeb.LivePage do
  use Phoenix.HTML
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <form phx-change="change" >
    <input type="text" name="text" value=<%= @text %> ></input>
    </form>
    <%= @text %>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, text: "")}
  end

  def handle_event("change", %{"text" => text}, socket) do
    {:noreply, assign(socket, text: text)}
  end
end
