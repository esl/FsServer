#------------------------------------------------------------------------------
# Author: Edward Tate <edward.tate@erlang-solutions.com>
#------------------------------------------------------------------------------

export reply, reply_close
export reply_stream, reply_stream_close
export reply_info
export noreply, noreply_close

#------------------------------------------------------------------------------
# Generic Server Functions
#------------------------------------------------------------------------------

function reply (s::Base.TcpSocket, x::Any)
    term, nbytes = encode_message((:reply, x))
    nbytes_written = write_erlang_term(s, term)
    nbytes_written
end

function reply_stream (s::Base.TcpSocket, bytes::Array{Uint8})
    term, nbytes = encode_message((:reply, length(bytes)))
    write_erlang_term(s, term)
    bin, nbytes = encode_message(bytes)
    write_binary_stream(s, bin)
end

function reply_stream_close (s::Base.TcpSocket, bytes::Array{Uint8})
    reply_stream(s, bytes)
    close(s)
end

function reply_close (s::Base.TcpSocket, x::Any)
    reply(s, x)
    close(s)
end

function reply_info (s::Base.TcpSocket, command::Symbol, options)
    term, nbytes = encode_message((:info, command, options))
    write_erlang_term(s, term)
end

function noreply (s::Base.TcpSocket)
    term, nbytes = encode_message(tuple(:noreply))
    write_erlang_term(s, term)
end

function noreply_close (s::Base.TcpSocket)
    noreply(s)
    close(s)
end

