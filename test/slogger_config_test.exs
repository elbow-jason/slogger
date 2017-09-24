defmodule SloggerConfigTestModule do
  use Slogger, level: :debug
  ####
  # this `level: :debug` is (read: should be) overridden
  # by the config.exs file
  ####

  def run do
    Slogger.debug("it failed if this shows up")
    Slogger.error("it worked if this shows up")
  end

end

defmodule SloggerConfigTest do
  use ExUnit.Case
  require SloggerConfigTestModule
  import ExUnit.CaptureIO


  test "log levels can be configured and overriden by a config.exs file" do
    # the module is configured directly, but overriden by the config
    fun = fn -> SloggerConfigTestModule.run end
    result1 =  capture_io(:stderr, fun)
    result2 =  capture_io(:stdio, fun)
    assert result1 |> String.contains?("it worked")
    refute result1 |> String.contains?("it failed")
    assert result2 == ""
  end

end
