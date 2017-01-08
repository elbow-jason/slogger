defmodule Slogger do
  @moduledoc """
  The unquoted expression in the __using__/1 macro `unquote((["Slogger", "Loggers"] ++ Module.split(__CALLER__.module)) |> Module.concat)`
  puts the generated logging module in question into a namespace under `Slogger.Loggers`.
  For example if `MyModule` has `use Slogger` then the module `Slogger.Loggers.MyModule` is
  generated and is the module that has the `alias` of Slogger in the `MyModule` namespace.
  """
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

      defmodule unquote((["Slogger", "Loggers"] ++ Module.split(__CALLER__.module)) |> Module.concat) do
        @levels [:debug, :info, :warn, :error]
        config = Application.get_env(:slogger, unquote(__CALLER__.module))

        @level config[:level] || unquote(opts[:level])  || :debug
        if not @level in @levels do
          raise "Slogger requires a level of one of the following #{inspect @levels}"
        end

        @handler config[:handler] || unquote(opts[:handler]) || Slogger.DefaultHandler
        if !@handler do
          raise "Slogger requires a valid handler module"
        end

        def handler, do: @handler
        def level,   do: @level

        Slogger.define_log_func(@handler, :debug, @level)
        Slogger.define_log_func(@handler, :info, @level)
        Slogger.define_log_func(@handler, :warn, @level)
        Slogger.define_log_func(@handler, :error, @level)

        def log(entry, level) when level in @levels do
          @handler.log(entry, level)
        end

      end

      @logger unquote((["Slogger", "Loggers"] ++ Module.split(__CALLER__.module)) |> Module.concat)

      def logger, do: @logger

      alias unquote((["Slogger", "Loggers"] ++ Module.split(__CALLER__.module)) |> Module.concat), as: Slogger
      # For some reason logger_as is not being shadowed into scope in the alias unqoutes. -JLG
      # logger_as = unquote(opts) |> Keyword.get(:as)
      # if logger_as do
      #   alias unquote Module.split(__CALLER__.module) |> Kernel.++([unquote(logger_as) |> Atom.to_string]) |> Module.concat
      # else
      #  alias unquote Module.split(__CALLER__.module) |> Kernel.++(["Slogger"]) |> Module.concat
      # end
    end
  end
end
