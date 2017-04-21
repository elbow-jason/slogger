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
    result =  capture_io(:stderr, fun)
    assert result |> String.contains?("it worked")
    refute result |> String.contains?("it failed")
  end

end
