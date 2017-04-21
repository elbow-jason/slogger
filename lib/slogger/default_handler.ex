defmodule Slogger.DefaultHandler do
  @behaviour Slogger.LogHandler

  @debug_color IO.ANSI.cyan
  @info_color  IO.ANSI.white
  @warn_color  IO.ANSI.yellow
  @error_color IO.ANSI.red
  @reset_color IO.ANSI.light_white

  def debug(entry), do: log(entry, :debug)
  def info(entry), do: log(entry, :info)
  def warn(entry), do: log(entry, :warn)
  def error(entry), do: log(entry, :error)

  def log(entry, :error = level) do
    IO.puts(:stderr, message(entry, level))
  end
  def log(entry, level) do
    IO.puts(message(entry, level))
  end

  defp message(entry, level) do
    color(level) <> format_time(now()) <> " [#{level}] " <> "#{entry}" <> @reset_color
  end

  defp color(level) do
    case level do
      :debug -> @debug_color
      :info ->  @info_color
      :warn ->  @warn_color
      :error -> @error_color
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
