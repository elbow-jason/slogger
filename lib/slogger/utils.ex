defmodule Slogger.Utils do
  def timestamp() do
    {_, _, microseconds} = time = :os.timestamp()
    {date, {hours, minutes, seconds}} = :calendar.now_to_universal_time(time)
    milliseconds = div(microseconds, 1000)
    {date, {hours, minutes, seconds, milliseconds}}
  end

  def render_message(msg) when is_function(msg, 0) do
    msg.()
  end

  def render_message(msg) when is_binary(msg) do
    msg
  end
end
