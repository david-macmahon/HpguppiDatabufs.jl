# HpguppiDatabufs

Live access to the shared memory buffers of an HPGUPPI DAQ process.

## Installation

Both this package and [`HashpipeDatabufs.jl`](
https://github.com/david-macmahon/HashpipeDatabufs.jl) are not (yet?) in the
General package registry so they must be installed from GitHub directly.  This
can be done using `Pkg` functions or using the `Pkg`-mode of the Julia REPL.

### Using `Pkg` functions

```julia
using Pkg
Pkg.add("https://github.com/david-macmahon/HashpipeDatabufs.jl")
Pkg.add("https://github.com/david-macmahon/HpguppiDatabufs.jl")
```

### Using `Pkg`-mode of the Julia REPL

In the Julia REPL, pressing `]` at the start of the line will switch the REPL
to `Pkg`-mode. . The prompe will change from `julia>` to `([env]) pkg>`, where
`[env]` is the name of the currently active environment (e.g. `@v1.9`).

```julia
julia> ]
(@v1.9) pkg> # Prompt changes immediately upon pressing `]`
(@v1.9) pkg> add https://github.com/david-macmahon/HashpipeDatabufs.jl
(@v1.9) pkg> add https://github.com/david-macmahon/HpguppiDatabufs.jl
```

Press backspace at the start of a line to switch back to the normal REPL mode.

## Using HpguppiDatabufs

This package provides HPGUPPI data block structs for use with `HashpipeDatabuf`.
The following block types are supported:

- GuppiRawBlock - A Hashpipe data block containing a GUPPI RAW `header` and an
                  associated `data` Array.  The `data` Array is currently
                  presented as a Vector (i.e. a 1-dimensional Array).  The user
                  can read the `header` field to find the actual dimensions and
                  `reshape` this Vector into a more meaningfully dimensioned
                  Array.

- PksuwlIbvpktBlock - A Hashpipe data block that contains a sequence of VDIF
                      packets.  Instead of presenting the packets as an Array of
                      packet structures, they are presented as three Arrays:
                      1. `net::Vector{UInt8}` - A Vector of network headers 
                      2. `vdif::Vector{UInt32}` - A Vector of VDIF headers 
                      3. `data::Vector{UInt16}` - A Vector of 16-bit samples

These data block structs are subtypes of `HashpipeDatabufs.AbstractBlock` for
use with `HashpipeDatabuf` constuctors.  Using the incorrect block type for the
specified data buffer will result in incorrect interpretation of the data
blocks.

To connect to an HPGUPPI databuf, simply pass the desired block type as a
parameter to the contructor.  For example, connecting to the first databuffer of
instance 0 using `PksuwlIbvpktBlock` structs for the data blocks can be done
like this:

```julia
julia> using HpguppiDatabufs

julia> hdb = HashpipeDatabuf{PksuwlIbvpktBlock}(0, 1)

julia> typeof(hdb.block)
Vector{PksuwlIbvpktBlock} (alias for Array{PksuwlIbvpktBlock, 1})

julia> hdb.block[1].vdif[1:3]
3-element Vector{Vector{UInt32}}:
 [0x00f4dbe7, 0x2e00c4ce, 0x20000404, 0xbc00504b, 0x00000000, 0x00000000, 0x00000000, 0xd76948a9]
 [0x00f4dbe7, 0x2e00c4cf, 0x20000404, 0xbc01504b, 0x00000000, 0x00000000, 0x00000000, 0xd7694892]
 [0x00f4dbe7, 0x2e00c4cf, 0x20000404, 0xbc00504b, 0x00000000, 0x00000000, 0x00000000, 0xd76948ab]
```
