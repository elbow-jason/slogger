defmodule Slogger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :slogger,
      version: "0.1.2",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
    ]
  end

  defp apps do
    [
      :logger,
    ]
  end
  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: apps
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
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
