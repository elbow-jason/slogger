defmodule Slogger.Application do
  use Application

  def start(_type, _args) do
    children = []
    Slogger.Table.start()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Utils.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
