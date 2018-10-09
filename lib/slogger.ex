defmodule Slogger do
  @moduledoc """

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
    Application.get_env(:slogger, :level, :info)
  end

  def default_formatter() do
    Application.get_env(:slogger, :format, "$date $time [$level] $metadata $message\n")
  end

  @spec should_log?(module() | log_level(), log_level()) :: boolean()
  def should_log?(module_level, level) when is_level(module_level) and is_level(level) do
    ordinal(module_level) <= ordinal(level)
  end

  def should_log?(module, level) do
    should_log?(module.get_level(), level)
  end

  @spec ordinal(:debug | :error | :info | :warn) :: 0 | 1 | 2 | 3
  defp ordinal(:debug), do: 0
  defp ordinal(:info), do: 1
  defp ordinal(:warn), do: 2
  defp ordinal(:error), do: 3

  def set_level(module, level) do
    configure(module, level: level)
  end

  def set_formatter(module, format) when is_binary(format) do
    configure(module, formatter: format, level: module.get_level())
  end

  defp parse_kwarg({:level, level}) when is_level(level), do: {:level, level}
  defp parse_kwarg({:formatter, f}) when is_list(f), do: {:formatter, f}
  defp parse_kwarg({:formatter, f}) when is_binary(f), do: {:formatter, Logger.Formatter.compile(f)}
  defp parse_kwarg({:module, module}) when is_atom(module), do: {:module, module}

  def configure(module, kwargs) when is_list(kwargs) do
    [{:module, module} | kwargs]
    |> Enum.map(&parse_kwarg/1)
    |> Table.upsert()
  end

  def get_level(module) do
    module.get_level()
  end

  defmacro __using__(opts) do
    quote do
      alias Slogger.State
      alias Logger.Formatter

      @log_level Keyword.get(unquote(opts), :level, Slogger.default_level())
      if @log_level not in Slogger.levels() do
        raise CompileError, message: "Slogger :level can only be one of #{inspect(Slogger.levels)}. Got #{inspect(@log_level)}"
      end

      @log_formatter_string unquote(opts) |> Keyword.get(:format, Slogger.default_formatter())
      @log_formatter Logger.Formatter.compile(@log_formatter_string)

      def level(level) do
        Slogger.set_level(__MODULE__, level)
      end

      def level() do
        case Table.fetch(__MODULE__) do
          :error ->  @log_level
          {:ok, %State{level: level}} -> level
        end
      end

      def format(formatter) do
        Slogger.set_formatter(__MODULE__, formatter)
      end

      def format() do
        case Table.fetch(__MODULE__) do
          :error ->
            @log_formatter
          {:ok, formatter} ->
            formatter
        end
      end

      defp default_state() do
        %State{module: __MODULE__, level: @log_level, formatter: Slogger.default_formatter()}
      end

      defp compile_formatter({_, _} = f) do
        Formatter.compile(f)
      end

      defp compile_formatter(f) when is_list(f) do
        f
      end

      defp compile_formatter(f) when is_binary(f) do
        Formatter.compile(f)
      end

      def log(level, message, meta \\ []) do
        state = case Table.fetch(__MODULE__) do
          {:ok, state} ->
            state
          :error ->
            default_state()
        end
        if Slogger.should_log?(state.level, level) do
          force_log(state, message, meta)
        end
        :ok
      end

      def force_log(state_level, message, meta \\ nil)
      def force_log(%State{module: module, formatter: nil, level: level}, message, meta) do
        {module, :format}
        |> compile_formatter()
        |> do_force_log(level, message, meta)
      end
      def force_log(%State{formatter: formatter, level: level}, message, meta) do
        formatter
        |> compile_formatter()
        |> do_force_log(level, message, meta)
      end

      def force_log(level, message, meta) when Slogger.is_level(level) do
        format()
        |> compile_formatter()
        |> do_force_log(level, message, meta)
      end

      defp do_force_log(pattern, level, message, meta) do
        timestamp = Slogger.Utils.timestamp()
        message = Slogger.Utils.render_message(message)
        data =
          pattern
          |> Formatter.format(level, message, timestamp, meta || [])
          |> :erlang.iolist_to_binary()
        case level do
          x when x in [:error, :warn] ->
            IO.puts(:stderr, data)
          _ ->
            IO.puts(data)
        end
      end



      def debug(entry, opts \\ []), do: log(:debug, entry, opts)
      def info(entry, opts \\ []), do: log(:info, entry, opts)
      def warn(entry, opts \\ []), do: log(:warn, entry, opts)
      def error(entry, opts \\ []), do: log(:error, entry, opts)
    end
  end
end
