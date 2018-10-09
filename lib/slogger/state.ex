defmodule Slogger.State do
  use Slogger.EtsModel, [
    module: nil,
    level: nil,
    formatter: nil,
  ]
end
