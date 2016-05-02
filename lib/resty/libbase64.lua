local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_str = ffi.string
local ffi_cdef = ffi.cdef
local ffi_load = ffi.load
local ffi_typeof = ffi.typeof

ffi_cdef[[
void base64_encode(const char *src, size_t srclen, char *out, size_t *outlen, int flags);
int  base64_decode(const char *src, size_t srclen, char *out, size_t *outlen, int flags);
]]

local lib = ffi_load "base64"

local base64 = {}
local ot = ffi_typeof "char[?]"
local sz = ffi_new "size_t[1]"
local bf = ffi_new(ot, 8192)

function base64.encode(src, len, flags)
    len = len or #src
    flags = flags or 0
    local osz = (len * 8 + 4) / 6
    local buf = osz < 8193 and bf or ffi_new(ot, osz)
    lib.base64_encode(src, len, buf, sz, flags)
    return ffi_str(buf, sz[0])
end

function base64.decode(src, len, flags)
    len = len or #src
    flags = flags or 0
    local osz = (len + 1) * 6 / 8
    local buf = osz < 8193 and bf or ffi_new(ot, osz)
    lib.base64_decode(src, len, buf, sz, flags)
    return ffi_str(buf, sz[0])
end

return base64