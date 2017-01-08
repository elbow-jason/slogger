# Slogger

Slogger is a simple logger that allows module level control of logging, and easily customizable logging.

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
      IO.puts "[#{level}] " <> "#{entry}"
    end

    def debug(entry), do: log(entry, :debug)
    def info(entry), do: log(entry, :info)
    def warn(entry), do: log(entry, :warn)
    def error(entry), do: log(entry, :error)
  end


  defmodule CustomHandlerSlogger do
    use Slogger, handler: GenericHandler

    def beep do
      Slogger.warn("BEEP")
    end

  end
```
