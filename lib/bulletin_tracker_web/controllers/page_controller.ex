defmodule BulletinTrackerWeb.PageController do
  use BulletinTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
