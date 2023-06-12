defmodule WebsiteWeb.CoreComponents do
  use WebsiteWeb, :verified_routes
  use Phoenix.Component

  import WebsiteWeb.Components.ColorSchemeSwitch

  alias Website.Utils

  @nav_links [
    %{to: "/", label: "Home"},
    %{to: "/about", label: "About"},
    %{to: "/projects", label: "Projects"}
  ]

  attr(:url, :string, required: true, doc: "The current url.")
  attr(:nav_links, :list, default: @nav_links, doc: "A list of nav links to be rendered.")
  attr(:class, :string, default: nil, doc: "A class to be added to the header.")

  def header(assigns) do
    ~H"""
    <div x-data="{ mobile_menu: false }">
      <header class={["flex items-center justify-between", @class]}>
      <.color_scheme_switch />

    <nav class="bg-white/90 ring-zinc-900/5 shadow-zinc-800/5 hidden rounded-full rounded-md px-6 text-zinc-800 shadow-lg ring-1 dark:ring-white/10 dark:bg-zinc-800 dark:text-zinc-100 md:block">
          <ul class="flex space-x-6 font-medium">
            <li
              :for={%{to: to, label: label} <- @nav_links}
              class={[
                "relative px-3 py-2",
                if(active?(@url, to),
                  do: "text-yellow-500 dark:text-yellow-400",
                  else: "hover:text-yellow-500 hover:dark:text-yello-400"
                )
              ]}
            >
              <.link navigate={to}>
                <%= label %>
              </.link>
              <span
                :if={active?(@url, to)}
                class="from-yellow-400/0 via-yellow-500/80 to-yellow-500/0 absolute inset-x-1 -bottom-px h-px bg-gradient-to-r dark:via-yellow-400/80 dark:to-yellow-400/0"
              >
              </span>
            </li>
          </ul>
        </nav>

        <div
          class="bg-white/90 ring-zinc-900/5 shadow-zinc-800/5 flex cursor-pointer items-center space-x-2 rounded-full px-4 py-2 text-zinc-800 shadow-lg ring-1 dark:ring-white/10 dark:bg-zinc-800 dark:text-zinc-100 md:hidden"
          @click="mobile_menu = true"
        >
          <p>Menu</p>
          <Heroicons.chevron_down solid class="h-5 w-5" />
        </div>


        <.mobile_nav />
      </header>
    </div>
    """
  end

  attr(:nav_links, :list, default: @nav_links, doc: "A list of nav links to be rendered.")

  def mobile_nav(assigns) do
    ~H"""
    <div x-show="mobile_menu" @keydown.escape.window="mobile_menu = false">
      <div class="bg-zinc-900/80 fixed inset-0 z-50 transition-opacity" />

      <div class="fixed inset-0 z-50 my-4 flex transform items-center justify-center overflow-hidden px-4 sm:px-6">
        <div
          @click.outside="mobile_menu = false"
          class="max-h-full w-full max-w-xl overflow-auto rounded bg-white shadow-lg dark:bg-zinc-800"
        >
          <div class="border-b border-gray-100 px-5 py-3 dark:border-zinc-700">
            <div class="flex items-center justify-between">
              <p class="font-semibold text-zinc-800 dark:text-gray-200">
                Navigation
              </p>

              <button @click="mobile_menu = false">
                <Heroicons.x_mark solid class="h-5 w-5 dark:text-white" />
              </button>
            </div>
          </div>
          <div class="p-5">
            <nav class="flex flex-col space-y-6">
              <.link
                :for={%{to: to, label: label} <- @nav_links}
                navigate={to}
                class="dark:text-gray-200"
              >
                <%= label %>
              </.link>
            </nav>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp active?(current, to) do
    %{path: path} = URI.parse(current)

    if to == "/", do: path == to, else: String.starts_with?(path, to)
  end

  attr(:class, :string, default: nil, doc: "Additional classes to be added to the footer.")
  attr(:url, :string, required: true, doc: "The current url.")
  attr(:nav_links, :list, default: @nav_links, doc: "A list of nav links to be rendered.")

  def footer(assigns) do
    ~H"""
    <footer class={["border-t border-zinc-300 dark:border-zinc-700", @class]}>
      <div class="flex flex-col items-center space-y-2 sm:justify-between md:flex-row md:space-y-0">
        <nav class="text-zinc-800 dark:text-zinc-100">
          <ul class="flex space-x-4 font-medium">
            <li :for={%{to: to, label: label} <- @nav_links}>
              <.link
                navigate={to}
                class={if active?(@url, to), do: "text-yellow-500 dark:text-yellow-400", else: ""}
              >
                <%= label %>
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </footer>
    """
  end

  attr(:socket, :map, required: true, doc: "The socket.")

  attr(:link, :string, required: true, doc: "The link to the project.")
  attr(:title, :string, required: true, doc: "The title of the project.")
  attr(:description, :string, required: true, doc: "The description of the project.")
  attr(:link_label, :string, required: true, doc: "The link label for the url.")

  def project_card(assigns) do
    ~H"""
    <.link
      href={@link}
      target="_blank"
      class="bg-zinc-200/30 group flex w-full flex-col space-y-3 rounded-xl p-5 dark:bg-zinc-800/30 lg:w-80"
    >
      <p class="font-medium text-zinc-800 dark:text-zinc-100">
        <%= @title %>
      </p>
      <p class="text-zinc-600 dark:text-zinc-400">
        <%= @description %>
      </p>
      <div class="flex grow flex-col justify-end pt-4">
        <div class="flex items-center space-x-2 text-zinc-800 dark:text-zinc-100">
          <Heroicons.link
            solid
            class="h-5 w-5 group-hover:text-yellow-500 dark:group-hover:text-yellow-400"
          />
          <p class="group-hover:text-yellow-500 dark:group-hover:text-yellow-400">
            <%= @link_label %>
          </p>
        </div>
      </div>
    </.link>
    """
  end

  attr(:class, :string, default: nil, doc: "Additional classes to be added to the icon.")

  def github_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 64 64"
      width="32px"
      height="32px"
      class={@class}
    >
      <path d="M32 6C17.641 6 6 17.641 6 32c0 12.277 8.512 22.56 19.955 25.286-.592-.141-1.179-.299-1.755-.479V50.85c0 0-.975.325-2.275.325-3.637 0-5.148-3.245-5.525-4.875-.229-.993-.827-1.934-1.469-2.509-.767-.684-1.126-.686-1.131-.92-.01-.491.658-.471.975-.471 1.625 0 2.857 1.729 3.429 2.623 1.417 2.207 2.938 2.577 3.721 2.577.975 0 1.817-.146 2.397-.426.268-1.888 1.108-3.57 2.478-4.774-6.097-1.219-10.4-4.716-10.4-10.4 0-2.928 1.175-5.619 3.133-7.792C19.333 23.641 19 22.494 19 20.625c0-1.235.086-2.751.65-4.225 0 0 3.708.026 7.205 3.338C28.469 19.268 30.196 19 32 19s3.531.268 5.145.738c3.497-3.312 7.205-3.338 7.205-3.338.567 1.474.65 2.99.65 4.225 0 2.015-.268 3.19-.432 3.697C46.466 26.475 47.6 29.124 47.6 32c0 5.684-4.303 9.181-10.4 10.4 1.628 1.43 2.6 3.513 2.6 5.85v8.557c-.576.181-1.162.338-1.755.479C49.488 54.56 58 44.277 58 32 58 17.641 46.359 6 32 6zM33.813 57.93C33.214 57.972 32.61 58 32 58 32.61 58 33.213 57.971 33.813 57.93zM37.786 57.346c-1.164.265-2.357.451-3.575.554C35.429 57.797 36.622 57.61 37.786 57.346zM32 58c-.61 0-1.214-.028-1.813-.07C30.787 57.971 31.39 58 32 58zM29.788 57.9c-1.217-.103-2.411-.289-3.574-.554C27.378 57.61 28.571 57.797 29.788 57.9z" />
    </svg>
    """
  end

  attr(:class, :string, default: nil, doc: "Additional classes to be added to the icon.")

  def linkedin_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 50 50"
      width="32px"
      height="32px"
      class={@class}
    >
      <path d="M41,4H9C6.24,4,4,6.24,4,9v32c0,2.76,2.24,5,5,5h32c2.76,0,5-2.24,5-5V9C46,6.24,43.76,4,41,4z M17,20v19h-6V20H17z M11,14.47c0-1.4,1.2-2.47,3-2.47s2.93,1.07,3,2.47c0,1.4-1.12,2.53-3,2.53C12.2,17,11,15.87,11,14.47z M39,39h-6c0,0,0-9.26,0-10 c0-2-1-4-3.5-4.04h-0.08C27,24.96,26,27.02,26,29c0,0.91,0,10,0,10h-6V20h6v2.56c0,0,1.93-2.56,5.81-2.56 c3.97,0,7.19,2.73,7.19,8.26V39z" />
    </svg>
    """
  end


  def theme_switch_light(assigns) do
    ~H"""
    <div class="ring-zinc-500/80 group flex h-8 w-8 cursor-pointer items-center justify-center rounded-full bg-zinc-800 ring-2 hover:ring-yellow-300">
      <Heroicons.sun solid class="h-6 w-6 text-zinc-100 group-hover:text-yellow-300" />
    </div>
    """
  end
end
