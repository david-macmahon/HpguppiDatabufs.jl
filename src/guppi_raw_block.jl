###
###  GuppiRawBlock
###

struct GuppiRawBlock <: AbstractBlock
    header::Array{UInt8,2}
    data::Vector{UInt8}
end

function GuppiRawBlock(p::Ptr{Nothing}, ::Int64)
    hdr = unsafe_wrap(Array, Ptr{UInt8}(p), (HEADER_REC_SIZE, HEADER_NUM_RECS))
    p += sizeof(hdr)
    data = unsafe_wrap(Array, Ptr{UInt8}(p), (BLOCK_DATA_SIZE))
    GuppiRawBlock(hdr, data)
end

function Base.sizeof(b::GuppiRawBlock)
    sizeof(b.header) + sizeof(d.data)
end
