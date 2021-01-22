defmodule Ex6502.CPU.Executor.LDX do
  @moduledoc """
  Load register x from memory

  ## Operation

  M -> X

  Load data from memory into the x register.

  ## Flags

  - Zero:     1 if register x is zero; 0 otherwise
  - Negative: 1 if bit 7 of register x is set; 0 otherwise
  """

  alias Ex6502.{CPU, Memory}

  use Bitwise

  # LDX Immediate (LDX #$nn)
  def execute(0xA2) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()

    CPU.set(:x, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # LDX Absolute (LDX $nnnn)
  def execute(0xAE) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.absolute()

    CPU.set(:x, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # LDX Y-indexed Absolute (LDX $nnnn,Y)
  def execute(0xBE) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.absolute(CPU.get(:y))

    CPU.set(:x, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # LDX zero-page (LDX $nn)
  def execute(0xA6) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.zero_page()

    CPU.set(:x, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # LDX Y-indexed zero-page (LDX $nn,Y)
  def execute(0xB6) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.zero_page(CPU.get(:y))

    CPU.set(:x, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  defp set_flags(value) do
    # is bit 7 a 1?
    CPU.set_flag(:n, (value &&& 1 <<< 7) >>> 7)
    CPU.set_flag(:z, value == 0)
  end
end
