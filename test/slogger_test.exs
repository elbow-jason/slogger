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

defmodule SloggerExample.MyModule do
  use Slogger

  def add(a, b) when b |> is_number and a |> is_number do
    Slogger.debug("adding a + b where a is #{a} and b is #{b}")
    sum = a + b
    Slogger.debug("equation: #{a} + #{b} = #{sum}")
    sum
  end

  def add(_, _) do
    Slogger.error("cannot add invalid values")
    :error
  end

end

defmodule SloggerTest do
  use ExUnit.Case
  doctest Slogger

  require SloggerExample.MyModule
  import ExUnit.CaptureIO

  test "logging works" do
    fun = fn -> SloggerExample.MyModule.add(1, 2) end
    result =  capture_io(fun)
    assert String.contains? result, " [debug] adding a + b where a is 1 and b is 2\n"
    assert String.contains? result, " [debug] equation: 1 + 2 = 3\n"
    assert String.starts_with? result, "\e[36m"
  end

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
  defmodule SloggerTest do
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
end
