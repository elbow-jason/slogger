defmodule Slogger.CaptureLog do
  alias ExUnit.CaptureIO

  def capture_log(func) when is_function(func, 0) do
    CaptureIO.capture_io(func)
  end

  def capture_log(device, func) when is_function(func, 0) do
    CaptureIO.capture_io(device, func)
  end

end
