defmodule Slogger.DefaultHandler do
  @behaviour Slogger.LogHandler

  def debug(entry), do: log(entry, :debug)
  def info(entry), do: log(entry, :info)
  def warn(entry), do: log(entry, :warn)
  def error(entry), do: log(entry, :error)

  def log(entry, level) do
    IO.puts(color(level) <> format_time(now) <> " [#{level}] " <> "#{entry}")
  end

  defp color(level) do
    case level do
      :debug -> IO.ANSI.cyan
      :info -> IO.ANSI.white
      :warn -> IO.ANSI.yellow
      :error -> IO.ANSI.red
    end
  end

  defp now do
    DateTime.utc_now
  end

  defp format_time(t) do
    "#{t.hour |> pad(2)}:#{t.minute |> pad(2)}:#{t.second |> pad(2)}.#{t.microsecond |> elem(0) |> pad(3)}"
  end

  defp pad(num, padding) do
    "#{num}"
    |> String.reverse
    |> Kernel.<>( String.duplicate("0", padding) )
    |> binary_part(0, padding)
    |> String.reverse
  end

end
