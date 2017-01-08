
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

```elixir

defmodule MySloggingModule do
  use Slogger

  def do_it do
    Slogger.debug("this won't log")
    Slogger.error("this will log")
  end

end

```

NOTE: the `config` in a `config.exs` file will overwrite other configuration options. This allows for maximal flexibility in your applications.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `slogger` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:slogger, "~> 0.1.0"}]
    end
    ```

  2. Ensure `slogger` is started before your application:

    ```elixir
    def application do
      [applications: [:slogger]]
    end
    ```
