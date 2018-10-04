
defmodule SloggerTest do
  use ExUnit.Case
  require Logger

  alias Slogger.{
    ConfigurableLogger,
    DebugLogger,
    InfoLogger,
    WarnLogger,
    ErrorLogger,
    NoLevelLogger
  }
  import Slogger.CaptureLog

  test "a module without a level defaults to default config" do
    level = Application.get_env(:slogger, :default_level)
    assert level in Slogger.levels()
    assert NoLevelLogger.get_level() == level
  end

  test "log can handle functions" do
    capture_log(fn -> DebugLogger.debug(fn -> "beef" end) end) =~ "beef"
  end

  test "default log level is configurable" do
    assert ConfigurableLogger.get_level() in Slogger.levels()
    assert :ok = ConfigurableLogger.set_level(:debug)
    assert ConfigurableLogger.get_level() == :debug
    assert :ok = ConfigurableLogger.set_level(:info)
    assert ConfigurableLogger.get_level() == :info
    assert :ok = ConfigurableLogger.set_level(:warn)
    assert ConfigurableLogger.get_level() == :warn
    assert :ok = ConfigurableLogger.set_level(:error)
    assert ConfigurableLogger.get_level() == :error
  end

  @letters ?a..?z |> Enum.into([]) |> MapSet.new()

  defp random_string(len) do
    Stream.repeatedly(fn -> Enum.random(@letters) end)
    |> Enum.take(len)
    |> :erlang.iolist_to_binary
  end

  def assert_logs(logger_func) when is_function(logger_func, 1) do
    string = random_string(20)
    assert capture_log(fn -> logger_func.(string) end) =~ string
  end

  def assert_does_not_log(logger_func) when is_function(logger_func, 1) do
    assert capture_log(fn -> logger_func.("should_not_log") end) == ""
  end

  describe "debug level setting" do
    test "logs all other levels" do
      assert DebugLogger.get_level() == :debug
      assert_logs(&DebugLogger.error/1)
      assert_logs(&DebugLogger.warn/1)
      assert_logs(&DebugLogger.info/1)
      assert_logs(&DebugLogger.debug/1)
    end
  end

  describe "info level setting" do
    test "does not log debug" do
      assert InfoLogger.get_level() == :info
      assert_does_not_log(&InfoLogger.debug/1)
    end

    test "logs levels info and above" do
      assert InfoLogger.get_level() == :info
      assert_logs(&InfoLogger.error/1)
      assert_logs(&InfoLogger.warn/1)
      assert_logs(&InfoLogger.info/1)
    end
  end

  describe "warn level setting" do
    test "does not log debug or info" do
      assert WarnLogger.get_level() == :warn
      assert_does_not_log(&WarnLogger.debug/1)
      assert_does_not_log(&WarnLogger.info/1)
    end

    test "logs levels warn and error" do
      assert WarnLogger.get_level() == :warn
      assert_logs(&WarnLogger.error/1)
      assert_logs(&WarnLogger.warn/1)
    end
  end

  describe "error level setting" do
    test "does not log debug, info, or warn" do
      assert ErrorLogger.get_level() == :error
      assert_does_not_log(&ErrorLogger.debug/1)
      assert_does_not_log(&ErrorLogger.info/1)
      assert_does_not_log(&ErrorLogger.warn/1)
    end

    test "logs levels warn and error" do
      assert ErrorLogger.get_level() == :error
      assert_logs(&ErrorLogger.error/1)
    end
  end
end
