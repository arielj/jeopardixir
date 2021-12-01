defmodule JeopardixirWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use JeopardixirWeb, :controller
      use JeopardixirWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: JeopardixirWeb

      import Jeopardixir.RequireUser, only: [require_user: 2]
      import Plug.Conn
      import JeopardixirWeb.Gettext
      alias JeopardixirWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      import JeopardixirWeb.Helpers.Auth, only: [signed_in?: 1]

      use Phoenix.View,
        root: "lib/jeopardixir_web/templates",
        namespace: JeopardixirWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import JeopardixirWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import JeopardixirWeb.ErrorHelpers
      import JeopardixirWeb.Gettext
      alias JeopardixirWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
