--[[--
Module for PNG decoding/encoding.

Currently, this is a LuaJIT FFI wrapper for lodepng lib.

@module ffi.png
]]

local ffi = require("ffi")
local _ = require("ffi/lodepng_h")

local lodepng
if ffi.os == "Windows" then
    lodepng = ffi.load("libs/liblodepng.dll")
elseif ffi.os == "OSX" then
    lodepng = ffi.load("libs/liblodepng.dylib")
else
    lodepng = ffi.load("libs/liblodepng.so")
end

local Png = {}

function Png.encodeToFile(filename, mem, w, h)
    local err = lodepng.lodepng_encode32_file(filename, mem, w, h)
    if err ~= 0 then
        local err_msg = lodepng.lodepng_error_text(err)
        return false, err_msg
    else
        return true
    end
end

function Png.decodeFromFile(filename, req_n)
    -- Read the file
    local fh = io.open(filename, "r")
    if not fh then
        return false, "couldn't open PNG file"
    end
    local fdata = fh:read("*a")
    fh:close()

    local ptr = ffi.new("unsigned char*[1]")
    local width = ffi.new("int[1]")
    local height = ffi.new("int[1]")
    local state = ffi.new("LodePNGState[1]")

    -- Init the state
    lodepng.lodepng_state_init(state);
    -- We'll always want 8-bits per component
    state[0].info_raw.bitdepth = 8

    -- Inspect the PNG data first, to see if we can avoid a color-type conversion
    local err = lodepng.lodepng_inspect(width, height, state, ffi.cast("const unsigned char*", fdata), #fdata);
    if err ~= 0 then
        return false, ffi.string(lodepng.lodepng_error_text(err))
    end

    -- Try to keep grayscale PNGs as-is if we requested so...
    if req_n == 1 then
        if state[0].info_png.color.colortype == lodepng.LCT_GREY or state[0].info_png.color.colortype == lodepng.LCT_GREY_ALPHA then
            state[0].info_raw.colortype = lodepng.LCT_GREY
        elseif state[0].info_png.color.colortype == lodepng.LCT_PALETTE and state[0].info_png.color.palettesize <= 16 then
            -- If input is sRGB, but paletted to 16c or less, assume it's the eInk palette, and honor it.
            -- Just expand it to grayscale so BB knows what to do with it ;).
            state[0].info_raw.colortype = lodepng.LCT_GREY
        else
            state[0].info_raw.colortype = lodepng.LCT_RGB
            -- Don't forget to update req_n so the caller is aware of the conversion
            req_n = 3
        end
    elseif req_n == 2 then
        if state[0].info_png.color.colortype == lodepng.LCT_GREY or state[0].info_png.color.colortype == lodepng.LCT_GREY_ALPHA then
            state[0].info_raw.colortype = lodepng.LCT_GREY_ALPHA
        elseif state[0].info_png.color.colortype == lodepng.LCT_PALETTE and state[0].info_png.color.palettesize <= 16 then
            -- If input is sRGB, but paletted to 16c or less, assume it's the eInk palette, and honor it.
            -- Just expand it to grayscale w/ alpha so BB knows what to do with it ;).
            state[0].info_raw.colortype = lodepng.LCT_GREY_ALPHA
        else
            state[0].info_raw.colortype = lodepng.LCT_RGBA
            -- Don't forget to update req_n so the caller is aware of the conversion
            req_n = 4
        end
    elseif req_n == 3 then
        state[0].info_raw.colortype = lodepng.LCT_RGB
    elseif req_n == 4 then
        state[0].info_raw.colortype = lodepng.LCT_RGBA
    else
        return false, "requested an invalid noumber of components"
    end

    err = lodepng.lodepng_decode(ptr, width, height, state, ffi.cast("const unsigned char*", fdata), #fdata)
    lodepng.lodepng_state_cleanup(state)
    if err ~= 0 then
        return false, ffi.string(lodepng.lodepng_error_text(err))
    else
        return true, {
            width = width[0],
            height = height[0],
            data = ptr[0],
            ncomp = req_n,
        }
    end
end

return Png
