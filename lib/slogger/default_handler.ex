defmodule Slogger.DefaultHandler do
  @behaviour Slogger.LogHandler

  def debug(entry), do: log(entry, :debug)
  def info(entry), do: log(entry, :info)
  def warn(entry), do: log(entry, :warn)
  def error(entry), do: log(entry, :error)

  def log(entry, level) do
    IO.puts(color(level) <> format_time(now) <> " [#{level}] " <> "#{entry}")
  end

  def color(level) do
    case level do
      :debug -> IO.ANSI.cyan
      :info -> IO.ANSI.white
      :warn -> IO.ANSI.yellow
      :error -> IO.ANSI.red
    end
  end

  def now do
    DateTime.utc_now
  end

  def format_time(t) do
    ms =
      t.microsecond
      |> elem(0)
      |> Kernel./(1000)
      |> round
    "#{t.hour}:#{t.minute}:#{t.second}.#{ms}"
  end

end
