defmodule Ex6502.CPU.Executor.LD do
  @moduledoc """
  Shared functions dealing with loading registers.
  """

  alias Ex6502.CPU

  use Bitwise

  def set_flags(value) do
    # is bit 7 a 1?
    CPU.set_flag(:n, (value &&& 1 <<< 7) >>> 7)
    CPU.set_flag(:z, value == 0)
  end
end
