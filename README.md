# Ex6502

Ex6502 is an emulation of the famous 6502 processor that was used in classic
computers of the 80s such as the Apple II series, Commodore 64, Atari 2600,
Nintendo Entertainment System (NES), and countless others. It is still being
manufactured by the millions anually, and this emulation is targeting the modern
versions of the CPU (65c02, W65C02S, etc.).

## Installation, documentation, and usage

Add `ex6502` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex6502, "~> 0.1.0"}
  ]
end
```

**Note that since this version is still pre-1.0, major API changes could occur
between any version number (major, minor, or patch level).** To see if breaking
changes occur between releases, check out the [CHANGELOG](CHANGELOG.md).

### Documentation

Documentation can be be found at
[https://hexdocs.pm/ex6502](https://hexdocs.pm/ex6502) or in the source code of
the modules themselves.

Even though you will likely never call a specific operation directly, each
operation has its own module and module documentation. For a good example, take
a look at the [source for
`CMP`](https://github.com/geolessel/ex6502/blob/main/lib/ex6502/cpu/executor/cmp.ex).

### Usage

Since this is in the earliest stages of usability, it's not exactly the most
user-friendly to get started with. If you'd like to dive in, I recommend the
following:

1. Assemble a generic, non-platform-specific hex file that contains your
   operations. A good example right now would be a routine to add two 32-bit
   numbers.

2. In some code or in an IEx session, set up your computer.

   ```elixir
   c =
     Ex6502.Computer.init()                               # initializes a Computer
     |> Ex6502.Computer.load_file("your-assembed-file")   # loads your program code into memory
     |> Ex6502.Computer.reset()                           # uses the 6502's reset vector to load the program counter
   ```

   As per the documentation for the 6502, when the CPU is reset, it fetches the
   16-bit address from memory locations 0xFFFC and 0xFFFD and sets the program
   counter to that address. Since the 6502 operates in little endian format, the
   low byle is stored first, then the high byte. That means that if your program
   code starts at 0xC000, you need values `0x00` and `0xC0` in bytes `0xFFFC`
   and `0xFFFD` respectively.

3. Single-step your computer with `Ex6502.Computer.step/1`:

   ```elixir
   c = Ex6502.Computer.set(c)
   ```

4. Run the program in its entirety with `Ex6502.Computer.run/1`:

   ```elixir
   c = Ex6502.Computer.run(c)
   ```

5. Inspect your memory locations with `Ex6502.Memory.inspect/3` or dump it all
   with `Ex6502.Memory.dump/2`:

   ```elixir
   # inspect 512 bytes of memory starting at location 0xC000
   Ex6502.Memory.inspect(c, 0xC000, 512)
   |> IO.puts()
   ```

#### Usage notes

I'm trying to emulate the hardware 6502 processor as closely as possible and
there are some potentially counter-intuitive pitfalls that you may fall into.
Here's a small list of things to remember.

* Zero-page memory addressing as the fastest way for the real processor to set
  and fetch data. While cycle speed emulation is not implemented (yet), it _is_
  nice to see some data in the zero page when inspecting memory since it is at
  the start of memory.

* As in the real CPU, the stack pointer is initialized to `0xFF`. However, since
  the stack lives in the address range of `0x0100` to `0x01FF`, the stack
  actually starts at address `0x01FF` and grows downwards towards `0x0100`. I
  would recommend against using any of those locations for program code or data.

* Currently, when the emulator encounters a `BRK` command (`0x00`) it does what
  the hardware does. Specifically, it pushes the high byte of the current
  address, then the low byte of the current address, then the current status
  register with the `B` flag set. After this, it sets the program counter to the
  "interrupt vector" address (`0xFFFE`). The emulator also stops the CPU and
  currently cannot continue automatically (though you can manually point the
  program counter anywhere you'd like at this point).

## Background

### Why do this?

Even though the most famous examples of usage of the 6502 were those systems, it
is actually a still-heavily used and produced CPU. While the machines of the
early 80s typically used the 6502 produced by MOS, the current producer of the
6502 processors is Western Design Center. [According to their
website](https://www.westerndesigncenter.com/), they still ship hundreds of
millions of units a year. While the majority of the operations handled by the
CPU are the same as when they were manufactured by MOS, the modern version adds
a few operations and removes all of the undocumented operations that the
original MOS 6502 had.

While it is not hard to find an emulation of a specific computer system (such as
the Apple II or Commodore 64), I had a hard time finding an emulator of the
processor itself. I had always had a curiosity about learning assembly
programming and from various sources I heard that the 6502 was a decent place to
start. Because of the popularity of the various computers that ran on the 6502,
there are LOADS of resources all over the internet and in (used) bookstores that
teach how to program for the 6502. I decided that's where I wanted to start.

But I could not find a good place to step through a piece of code and see what
the processor was actually doing with the operation. So I built this.

With this baseline 6502 emulation, I have focused on the modern version of the
6502, as produced by Western Design Center. While every documented opcode is
implemented already (and a simple disassembler is as well), there are likely
some flaws in my emulation. I did not study other people's emulations of the
CPU, nor did I do much research on emulation itself. I basically dove right in.
Because of this, I'm 100% positive there are better ways to do some things I've
done. But the main thing is: it seems to work.

### Pitch in

If this project interests you, please pitch in and help make this codebase
better. You can see in my earliest commits I wasn't quite sure where I was
headed. But by the end of the opcode implementations, I had found a good pattern
and settled into that.

Most of the code is likely much more verbose that it needs to be and I'm OK with
that. I don't mind a bit of duplication so that I (or others learning the 6502)
can better understand what is going on inside the processor.

### Put this emulation into a larger system emulator

Since this is just an emulation of the CPU itself, I believe it can be used to
program multiple various sytems that included the 6502 (such as the Apple II or
Commodore 64). While I may tackle some of those larger system emulations myself
at some point, feel free to take this CPU emulation and build a more robust
emulator around it.

If you do create such an emulation, PLEASE let me know about it. I'd love to use
what you've created.

## Wishlist

* [x] every opcode implemented
* [x] basic disassembler
* [ ] documentation for public APIs
* [ ] typespecs for public APIs
* [ ] correct operation tables for each opcode
* [ ] refactor earliest operation implementations
* [ ] correctly count cycles used during processing
* [ ] time-correct emulation of the CPU (running at original speeds such as 1MHz, but also configurable)
* [ ] handle continuation from `BRK` interrupts
* [ ] emulate hardware interrupts
* [ ] basic assembler?

## Me

Contact me any time! I'm [@geolessel](https://twitter.com/geolessel) on twitter,
"geo" in the Elixir Slack community, and
[geo](https://elixirforum.com/u/geo/summary) on elixirforum.com.

If you like my work and want to support me, feel free to buy my book, [Phoenix
in Action](http://phoenixinaction.com) from Manning Publishing. If you already
have the book, please leave a review on any major online retailer or community
-- it really does help. If you've already done that or don't like reading (how
did you get this far into the README?), contact me directly and I'm sure we can
figure some way.
