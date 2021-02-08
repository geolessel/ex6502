defmodule Ex6502.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/geolessel/ex6502"

  def project do
    [
      app: :ex6502,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ex6502.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    An emulation of the famous 6502 processor. Focus is on modern versions
    of the processor (as opposed to the MOS 6502 version).
    """
  end

  defp package do
    [
      name: :ex6502,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Geoffrey Lessel"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      name: "Ex6502",
      source_url: @source_url,
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
