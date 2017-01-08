defmodule MyUsableModule do
  defmacro __using__(_opts) do
    quote do
      use Slogger, level: :info

      def run do
        #IO.inspect Code.ensure_loaded(Slogger)
        Slogger.warn("this should work")
        Slogger.debug("failure if this shows up")
      end
    end
  end
end

defmodule MyInjectedModule do
  require MyUsableModule
  use MyUsableModule

end

defmodule SloggerUsableMacroTest do
  use ExUnit.Case
  doctest Slogger

  require MyInjectedModule
  import ExUnit.CaptureIO

  test "Slogger is useable inside macros" do
    fun = fn -> MyInjectedModule.run end
    result =  capture_io(fun)
    assert result |> String.contains?("this should work")
    refute result |> String.contains?("failure")
  end

end
