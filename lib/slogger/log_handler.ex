defmodule Slogger.LogHandler do
  @type level :: :debug | :info | :warn | :error
  @type entry :: IO.chardata | String.Chars.t

  @callback log(entry, level) :: :ok
  @callback debug(entry) :: :ok
  @callback info(entry) :: :ok
  @callback warn(entry) :: :ok
  @callback error(entry) :: :ok
end
