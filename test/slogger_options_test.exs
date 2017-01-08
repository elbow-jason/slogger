defmodule GenericHandler do
  @behaviour Slogger.LogHandler

  def log(entry, level) do
    IO.puts "[#{level}] " <> "#{entry}"
  end

  def debug(entry), do: log(entry, :debug)
  def info(entry), do: log(entry, :info)
  def warn(entry), do: log(entry, :warn)
  def error(entry), do: log(entry, :error)
end


defmodule SloggerHandlerTestModule do
  use Slogger, handler: GenericHandler, level: :info

  def run(entry, level) do
    Slogger.log(entry, level)
  end

  def silent_debug(thing) do
    Slogger.debug(thing)
  end
end


defmodule SloggerHandlerTest do
  use ExUnit.Case
  doctest Slogger

  require SloggerHandlerTestModule
  import ExUnit.CaptureIO

  test "custom handler's log works" do
    fun = fn -> SloggerHandlerTestModule.run("Hello World", :debug) end
    result =  capture_io(fun)
    assert result == "[debug] Hello World\n"
  end

  test "custom handler is silent when level is set above called level" do
    fun = fn -> SloggerHandlerTestModule.silent_debug("Hello World") end
    result = capture_io(fun)
    assert result == ""
  end

end
