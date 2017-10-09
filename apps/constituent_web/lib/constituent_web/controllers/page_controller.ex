defmodule ConstituentWeb.PageController do
  use ConstituentWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
