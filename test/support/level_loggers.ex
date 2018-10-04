defmodule Slogger.DebugLogger do
  use Slogger, level: :debug
end

defmodule Slogger.InfoLogger do
  use Slogger, level: :info
end

defmodule Slogger.WarnLogger do
  use Slogger, level: :warn
end

defmodule Slogger.ErrorLogger do
  use Slogger, level: :error
end

defmodule Slogger.NoLevelLogger do
  use Slogger
end

defmodule Slogger.ConfigurableLogger do
  use Slogger
end
