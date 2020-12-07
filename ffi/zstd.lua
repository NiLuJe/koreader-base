--[[--
LuaJIT FFI wrapper for ZSTD.

@module ffi.zstd
]]

local ffi = require("ffi")
local C = ffi.C

local posix = require("ffi/posix_h") -- luacheck: ignore 211
local _ = require("ffi/zstd_h")

local zst
if ffi.os == "Windows" then
    zst = ffi.load("libs/libzstd.dll")
elseif ffi.os == "OSX" then
    zst = ffi.load("libs/libzstd.1.dylib")
else
    zst = ffi.load("libs/libzstd.so.1")
end

local zstd = {}

-- c.f., https://github.com/facebook/zstd/tree/dev/examples
function zstd.zstd_compress(ptr, size)
    --print("zstd_compress:", ptr, size)
    local n = zst.ZSTD_compressBound(size)
    local cbuff = C.calloc(n, 1)
    assert(cbuff ~= nil, "Failed to allocate ZSTD compression buffer (" .. tonumber(n) .. " bytes)")
    -- NOTE: We should be quite all right with the default (3), which will most likely trounce zlib's 9 in every respect...
    local clen = zst.ZSTD_compress(cbuff, n, ptr, size, zst.ZSTD_CLEVEL_DEFAULT)
    assert(zst.ZSTD_isError(clen) == 0, ffi.string(zst.ZSTD_getErrorName(clen)))
    return cbuff, clen
end

function zstd.zstd_uncompress(ptr, size)
    --print("zstd_uncompress:", ptr, size)
    -- The decompressed size is encoded in the ZST frame header
    local n = zst.ZSTD_getFrameContentSize(ptr, size)
    local buff = C.calloc(n, 1)
    assert(buff ~= nil, "Failed to allocate ZSTD decompression buffer (" .. tonumber(n) .. " bytes)")
    local ulen = zst.ZSTD_decompress(buff, n, ptr, size)
    assert(zst.ZSTD_isError(ulen) == 0, ffi.string(zst.ZSTD_getErrorName(ulen)))
    return buff, ulen
end

-- Same idea, but with a re-usable decompression context
-- NOTE: We currently don't bother with that for compression,
--       since the only user (BookInfoManager) runs that in a subprocess anyway.

-- More for correctness than anything, make sure the GC will actually free the resources
-- when a table tagged DCtx_mt goes out of scope...
local DCtx_mt = {}
function DCtx_mt:free()
    if self.ptr then
        zst.ZSTD_freeDCtx(self.ptr)
        self.ptr = nil
    end
end
DCtx_mt.__gc = DCtx_mt.free
local dctx = {}
setmetatable(dctx, DCtx_mt)

function zstd.zstd_uncompress_ctx(ptr, size)
    --print("zstd_uncompress_ctx:", ptr, size)

    -- Lazy init the decompression context
    if not dctx.ptr then
        dctx.ptr = zst.ZSTD_createDCtx()
        assert(dctx.ptr ~= nil, "Failed to allocate ZSTD decompression context")
    else
        -- Reset the context
        local ret = zst.ZSTD_DCtx_reset(dctx.ptr, zst.ZSTD_reset_session_only)
        assert(zst.ZSTD_isError(ret) == 0, ffi.string(zst.ZSTD_getErrorName(ret)))
    end

    -- The decompressed size is encoded in the ZST frame header
    local n = zst.ZSTD_getFrameContentSize(ptr, size)
    local buff = C.calloc(n, 1)
    assert(buff ~= nil, "Failed to allocate ZSTD decompression buffer (" .. tonumber(n) .. " bytes)")
    local ulen = zst.ZSTD_decompressDCtx(dctx.ptr, buff, n, ptr, size)
    assert(zst.ZSTD_isError(ulen) == 0, ffi.string(zst.ZSTD_getErrorName(ulen)))
    return buff, ulen
end

return zstd
