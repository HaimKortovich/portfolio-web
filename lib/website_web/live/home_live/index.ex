defmodule WebsiteWeb.HomeLive.Index do
  use WebsiteWeb, :live_view

  alias Website.Repo

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Haim Kortovich · Software Engineer")

    {:ok, socket}
  end
end
