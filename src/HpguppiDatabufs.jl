module HpguppiDatabufs

using HashpipeDatabufs

export GuppiRawBlock
export PksuwlIbvpktBlock

# Re-export the module
export HashpipeDatabufs
# Re-export the struct
export HashpipeDatabuf
# Re-export functions
export get_block_states
export get_block_states!
export states_to_bitmask

"""
Used to ensure favorable memory alignment
"""
const ALIGNMENT_SIZE = 4096

"""
Used to ensure favorable AVX instruction alignment
"""
const AVX_ALIGNMENT_SIZE = 64

"""
Header record size
"""
const HEADER_REC_SIZE = 80

"""
Number of records in a header
"""
const HEADER_NUM_RECS = 2560

"""
Size of a data portion of a data block
"""
const BLOCK_DATA_SIZE = 128 * 1024 * 1024 # 128 MiB

"""
Number of bytes per PKSUWL packet network header
"""
const PKSUWL_NETHDR_BYTES = 46

"""
Number of UInt32 "elements" per PKSUWL packet VDIF header
"""
const PKSUWL_VDIF_ELEMENTS = 8

"""
Number of UInt16 "elements" per PKSUWL packet data payload
"""
const PKSUWL_DATA_ELEMENTS = 4096

"""
Number of "extra" bytes at end of packet.
"""
const PKSUWL_EXTRA_BYTES = 6

"""
    pad(sz, n)

Returns first multiple of `n` that is greater than or equal to `sz`.
"""
function pad(sz, n)
    cld(sz, n) * n
end

"""
    padavx(sz)

Returns first multiple of `AVX_ALIGNMENT_SIZE` that is greater than or equal to
`sz`.  Equivalent to `pad(sz, AVX_ALIGNMENT_SIZE)`.
"""
function padavx(sz)
    pad(sz, AVX_ALIGNMENT_SIZE)
end

include("guppi_raw_block.jl")
include("pksuwl_ibvpkt_block.jl")

end # module HpguppiDatabufs