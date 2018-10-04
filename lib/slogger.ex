defmodule Slogger do
  @moduledoc """
  The unquoted expression in the __using__/1 macro `unquote((["Slogger", "Loggers"] ++ Module.split(__CALLER__.module)) |> Module.concat)`
  puts the generated logging module in question into a namespace under `Slogger.Loggers`.
  For example if `MyModule` has `use Slogger` then the module `Slogger.Loggers.MyModule` is
  generated and is the module that has the `alias` of Slogger in the `MyModule` namespace.
  """
  alias Slogger.Table

  @levels [:debug, :info, :warn, :error]
  @type log_level :: :debug | :info | :warn | :error

  defguard is_level(item) when item in @levels

  def levels() do
    @levels
  end

  @spec default_level() :: log_level()
  def default_level() do
    Application.get_env(:slogger, :default_level) || :info
  end

  @spec should_log?(module(), log_level()) :: boolean()
  def should_log?(module, level) do
    ordinal(module.get_level()) <= ordinal(level)
  end

  @spec ordinal(:debug | :error | :info | :warn) :: 0 | 1 | 2 | 3
  defp ordinal(:debug), do: 0
  defp ordinal(:info), do: 1
  defp ordinal(:warn), do: 2
  defp ordinal(:error), do: 3

  def set_level(module, level) when is_level(level) do
    Table.start()
    Table.set_level(module, level)
  end

  def get_level(module) do
    module.get_level()
  end

  defmacro __using__(opts) do
    quote do
      @log_level Keyword.get(unquote(opts), :level, Slogger.default_level())
      if @log_level not in Slogger.levels() do
        raise CompileError, message: "Slogger :lavel can only be one of #{inspect(Slogger.levels)}. Got #{inspect(@log_level)}"
      end

      def set_level(level) do
        Slogger.set_level(__MODULE__, level)
      end

      def get_level() do
        Table.get_level(__MODULE__) || @log_level
      end

      def log(level, entry, opts \\ []) do
        if Slogger.should_log?(__MODULE__, level) do
          bare_log(level, entry, opts)
        end
        :ok
      end

      def bare_log(level, entry, opts \\ []) do
        Logger.bare_log(level, entry, opts)
      end

      def debug(entry, opts \\ []), do: log(:debug, entry, opts)
      def info(entry, opts \\ []), do: log(:info, entry, opts)
      def warn(entry, opts \\ []), do: log(:warn, entry, opts)
      def error(entry, opts \\ []), do: log(:error, entry, opts)
    end
  end
end
