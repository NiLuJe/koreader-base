#include <zstd.h>

#include "ffi-cdecl.h"

cdecl_const(ZSTD_CLEVEL_DEFAULT)
cdecl_func(ZSTD_compress)

cdecl_func(ZSTD_decompress)
cdecl_const(ZSTD_CONTENTSIZE_UNKNOWN)
cdecl_const(ZSTD_CONTENTSIZE_ERROR)
cdecl_func(ZSTD_getFrameContentSize)
cdecl_func(ZSTD_findFrameCompressedSize)

//cdecl_func(ZSTD_COMPRESSBOUND)
cdecl_func(ZSTD_compressBound)
cdecl_func(ZSTD_isError)
cdecl_func(ZSTD_getErrorName)
cdecl_func(ZSTD_minCLevel)
cdecl_func(ZSTD_maxCLevel)

cdecl_struct(ZSTD_CCtx_s)
cdecl_type(ZSTD_CCtx)
cdecl_func(ZSTD_createCCtx)
cdecl_func(ZSTD_freeCCtx)
cdecl_func(ZSTD_compressCCtx)

cdecl_struct(ZSTD_DCtx_s)
cdecl_type(ZSTD_DCtx)
cdecl_func(ZSTD_createDCtx)
cdecl_func(ZSTD_freeDCtx)
cdecl_func(ZSTD_decompressDCtx)

cdecl_type(ZSTD_strategy)
cdecl_type(ZSTD_cParameter)
cdecl_type(ZSTD_bounds)
cdecl_func(ZSTD_cParam_getBounds)
cdecl_func(ZSTD_CCtx_setParameter)
cdecl_func(ZSTD_CCtx_setPledgedSrcSize)
cdecl_type(ZSTD_ResetDirective)
cdecl_func(ZSTD_CCtx_reset)
cdecl_func(ZSTD_compress2)

cdecl_type(ZSTD_dParameter)
cdecl_func(ZSTD_dParam_getBounds)
cdecl_func(ZSTD_DCtx_setParameter)
cdecl_func(ZSTD_DCtx_reset)
