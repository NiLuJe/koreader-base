--[[--
LuaJIT FFI wrapper for ZSTD.

@module ffi.zstd
]]

local ffi = require("ffi")
local _ = require("ffi/zstd_h")

local zst
if ffi.os == "Windows" then
    zst = ffi.load("libs/zstd.dll")
elseif ffi.os == "OSX" then
    zst = ffi.load("libs/zstd.1.dylib")
else
    zst = ffi.load("libs/zstd.so.1")
end

local zstd = {}

-- c.f., https://github.com/facebook/zstd/tree/dev/examples
function zstd.zstd_compress(data)
    local n = zst.ZSTD_compressBound(#data)
    local cbuff = ffi.new("uint8_t[?]", n)
    local clen = ZSTD_compress(cbuff, n, data, #data, zst.ZSTD_CLEVEL_DEFAULT)
    assert(zst.ZSTD_isError(res) == 0)
    return ffi.string(cbuff, clen)
end

function zstd.zstd_uncompress(zstdata, ulen)
    -- We technically no longer need ulen, the decompressed size is encoded in the ZST frame header
    local n = zst.ZSTD_getFrameContentSize(zstdata, #zstdata)
    local buff = ffi.new("uint8_t[?]", n)
    local len = zst.ZSTD_decompress(buff, n, zstdata, #zstdata)
    assert(zst.ZSTD_isError(len) == 0)
    return ffi.string(buff, len)
end

return zstd
