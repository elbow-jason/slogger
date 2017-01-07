defmodule Slogger do
  @levels [:debug, :info, :warn, :error]

  @level_ordinal [
    debug: 0,
    info:  1,
    warn:  2,
    error: 3,
  ]

  def is_gte?(level_a, level_b) when level_a in @levels and level_b in @levels do
    @level_ordinal[level_a] >= @level_ordinal[level_b]
  end

  defmacro define_log_func(handler, level, config_level) do
    quote do
      if Slogger.is_gte?(unquote(level), unquote(config_level)) do
        def unquote(level)(entry) do
          apply(unquote(handler), unquote(level), [entry])
        end
      else
        def unquote(level)(_) do
          :ok
        end
      end

    end
  end


  defmacro __using__(opts) do
    quote do
      @levels [:debug, :info, :warn, :error]

      @level unquote(opts[:level]) || :debug
      if not @level in @levels do
        raise "Slogger requires a level of one of the following #{inspect @levels}"
      end

      @handler unquote(opts[:handler]) || Slogger.DefaultHandler
      if !@handler do
        raise "Slogger requires a valid handler module"
      end

      def handler, do: @handler
      def level,   do: @level

      Slogger.define_log_func(handler, :debug, @level)
      Slogger.define_log_func(handler, :info, @level)
      Slogger.define_log_func(handler, :warn, @level)
      Slogger.define_log_func(handler, :error, @level)

    end
  end
end
