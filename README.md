
<p align="center">
    <img height="100" width="100" src="http://i.imgur.com/qybqMMx.png">
</p>
<p align="center">
  Simple Module-Level Logging
</p>

# Slogger

[![Build Status](https://travis-ci.org/elbow-jason/slogger.svg?branch=master)](https://travis-ci.org/elbow-jason/slogger)

Slogger is a simple logger that allows flexible, and easily customizable, module-level control of logging.

## Usage

Simple:

```elixir
defmodule SimpleSlogger do
  use Slogger
  # this module's Slogger is set to the default, :debug

  def add(a, b) when b |> is_number and a |> is_number do
    Slogger.debug("equation: #{a} + #{b} = x")
    sum = a + b
    Slogger.debug("result: x = #{sum}")
    sum
  end

end
```

With a logging level:

```elixir
  defmodule LeveledSlogger do
    use Slogger, level: :info
    # you can configure slogger log level directly in the module.
    # or you can configure the log level in the
    # config.exs files as in one of the examples below

    def is_one?(1) do
      # you will not see this debug log entry
      Slogger.debug("it was one")
      true
    end
    def is_one?(_) do
      # you will see this error log entry
      Slogger.error("WOOP WOOP WOOP ALARM. NOT ONE.")
      false
    end

  end
```

With a custom handler:

```elixir
  defmodule RobotHandler do
    @behaviour Slogger.LogHandler

    def log(entry, level) do
      IO.puts "Robot says, in [#{level}] voice, \"" <> "#{entry}" <> "\""
    end

    def debug(entry), do: log(entry, :debug)
    def info(entry), do: log(entry, :info)
    def warn(entry), do: log(entry, :warn)
    def error(entry), do: log(entry, :error)
  end


  defmodule CustomHandlerSlogger do
    use Slogger, handler: RobotHandler

    def beep do
      Slogger.warn("BEEP")
    end

  end
```

Configure using the config.exs file:

```elixir
  # in config.exs
  use Mix.Config

  config :slogger, MySloggingModule,
    level: :error
```

Setting the level in the config.exs overrides any log level set in
the module:

```elixir

defmodule MySloggingModule do
  use Slogger, level: :debug # this is ignored because we set the level in the config.exs

  def do_it do
    Slogger.debug("this won't log")
    Slogger.error("this will log")
  end

end

```

NOTE: the `config` in a `config.exs` file will overwrite other configuration options. This allows for maximal flexibility in your applications.

## Installation

[Slogger](https://hex.pm/packages/slogger) is available on hex.pm. To use Slogger, add `slogger` to your list of dependencies in `mix.exs`:

```elixir

def deps do
  [{:slogger, "~> 0.1.6"}]
end

```

## TODOS

 - [ ] Add more documentation
