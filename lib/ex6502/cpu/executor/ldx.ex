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

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> CPU.set(:x)
    |> CPU.set_flags([:n, :z], :x)
  end

  # LDX Immediate (LDX #$nn)
  def do_execute(%Computer{data_bus: 0xA2} = c) do
    c
    |> Computer.put_next_byte_on_data_bus()
  end

  # LDX Absolute (LDX $nnnn)
  def do_execute(%Computer{data_bus: 0xAE} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute()
  end

  # LDX Y-indexed Absolute (LDX $nnnn,Y)
  def do_execute(%Computer{data_bus: 0xBE} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute(c.cpu.y)
  end

  # LDX zero-page (LDX $nn)
  def do_execute(%Computer{data_bus: 0xA6} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.absolute()
  end

  # LDX Y-indexed zero-page (LDX $nn,Y)
  def do_execute(%Computer{data_bus: 0xB6} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.absolute(c.cpu.y)
  end
end
