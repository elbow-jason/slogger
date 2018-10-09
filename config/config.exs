use Mix.Config

config :slogger,
  level: :info,
  format: "$date $time [$level] $metadata $message\n",
  table: :slogger_levels


