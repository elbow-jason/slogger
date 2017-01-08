use Mix.Config

# this is here to test the config file overrides all other configurations
config :slogger, SloggerConfigTestModule,
  level: :error
