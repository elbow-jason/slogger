defmodule SloggerExample.MyModule do
  use Slogger

  def add(a, b) do
    debug("adding a + b where a is #{a} and b is #{b}")
    sum = a + b
    debug("equation: #{a} + #{b} = #{sum}")
    sum
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
