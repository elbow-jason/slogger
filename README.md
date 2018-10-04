
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
  # this module's Slogger is set to the default :info
end
```

With a logging level:

```elixir
  defmodule LeveledSlogger do
    use Slogger, level: :debug
    # you can configure slogger log level directly in the module.
  end

  defmodule MyModule do
    def is_one?(1) do
      # you will not see this debug log entry
      LeveledSlogger.debug("it was one")
      true
    end
    def is_one?(_) do
      # you will see this error log entry
      LeveledSlogger.error("WOOP WOOP WOOP ALARM. NOT ONE.")
      false
    end
  end
```

## Installation

[Slogger](https://hex.pm/packages/slogger) is available on hex.pm. To use Slogger, add `slogger` to your list of dependencies in `mix.exs`:

```elixir

def deps do
  [{:slogger, "~> 0.2.0"}]
end

```
