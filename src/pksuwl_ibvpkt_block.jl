###
###  PksuwlIbvpktBlock
###

struct PksuwlIbvpktBlock <: AbstractBlock
    net::Vector{Vector{UInt8}}
    vdif::Vector{Vector{UInt32}}
    data::Vector{Vector{UInt16}}
end

function PksuwlIbvpktBlock(p::Ptr{Nothing}, ::Int64)
    # Skip HPGUPPI data block header
    p += HEADER_REC_SIZE * HEADER_NUM_RECS
    net_size = padavx(PKSUWL_NETHDR_BYTES)
    vdif_size = padavx(PKSUWL_VDIF_ELEMENTS * sizeof(UInt32))
    data_size = padavx(PKSUWL_DATA_ELEMENTS * sizeof(UInt16) + PKSUWL_EXTRA_BYTES)
    slot_size = net_size + vdif_size + data_size
    n = BLOCK_DATA_SIZE ÷ slot_size
    net = Vector{Vector{UInt8}}(undef, n)
    vdif = Vector{Vector{UInt32}}(undef, n)
    data = Vector{Vector{UInt16}}(undef, n)
    for i in 1:n
        net[i] = unsafe_wrap(Array, Ptr{UInt8}(p), (PKSUWL_NETHDR_BYTES))
        p += net_size
        vdif[i] = unsafe_wrap(Array, Ptr{UInt32}(p), (PKSUWL_VDIF_ELEMENTS))
        p += vdif_size
        data[i] = unsafe_wrap(Array, Ptr{UInt16}(p), (PKSUWL_DATA_ELEMENTS))
        p += data_size
    end
    PksuwlIbvpktBlock(net, vdif, data)
end

function Base.sizeof(b::PksuwlIbvpktBlock)
    slot_size = padavx(PKSUWL_NETHDR_BYTES) +
                padavx(PKSUWL_VDIF_ELEMENTS * sizeof(UInt32)) +
                padavx(PKSUWL_DATA_ELEMENTS * sizeof(UInt16) + PKSUWL_EXTRA_BYTES)
    sizeof(b.header) + length(b.data) * slot_size
end
