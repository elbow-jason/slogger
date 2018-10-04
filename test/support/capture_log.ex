defmodule Slogger.CaptureLog do
  alias ExUnit.CaptureIO

  def capture_log(func) when is_function(func, 0) do
    CaptureIO.capture_io(:user, fn ->
      func.()
      Logger.flush()
    end)
  end

end
