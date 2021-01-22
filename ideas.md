# Ideas

Random thoughts I have during development.

## Code/Data flow

How would I like to see this work in a data flow manner? I don't know if the
global GenServer idea is the best one here. I like the idea of having each
function being passed a struct and it just modifies what it needs to in that
struct as it passes it down the pipeline.

Maybe this?

```elixir
c = %Computer{cpu: %CPU{}, memory: %Memory{}, cycle: 0, data: 0x33}
# `data` represents what is on the data bus?

c
|> fetch_opcode()
|> process_opcode()
```

To process the opcode, the matching function would make multiple touches

```elixir
def lda(0xad) do

end
```

* There is a maximum of 3-byte opcodes, meaning I could potentially
  `Enum.slice(memory, pc, 3)` and pattern match on the first element of the List
