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
