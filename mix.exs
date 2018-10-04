defmodule Slogger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :slogger,
      version: "0.2.1",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
    ]
  end

  defp apps do
    [
      :logger,
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      applications: apps()
    ]
  end

  defp deps do
    [
       {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp description do
    """
    Slogger is a simple logger that allows flexible, and easily customizable, module-level control of logging.
    """
  end

  defp package do
    [# These are the default files included in the package
      name: :slogger,
      files: ["lib", "mix.exs", "README*", "LICENSE*",],
      maintainers: ["Jason Goldberger"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/elbow-jason/slogger",
      }
    ]
   end

end
