local ffi = require("ffi")

ffi.cdef[[
static const int ZSTD_CLEVEL_DEFAULT = 3;
size_t ZSTD_compress(void *, size_t, const void *, size_t, int) __attribute__((visibility("default")));
size_t ZSTD_decompress(void *, size_t, const void *, size_t) __attribute__((visibility("default")));
static const int ZSTD_CONTENTSIZE_UNKNOWN = -1;
static const int ZSTD_CONTENTSIZE_ERROR = -2;
long long unsigned int ZSTD_getFrameContentSize(const void *, size_t) __attribute__((visibility("default")));
size_t ZSTD_findFrameCompressedSize(const void *, size_t) __attribute__((visibility("default")));
size_t ZSTD_compressBound(size_t) __attribute__((visibility("default")));
unsigned int ZSTD_isError(size_t) __attribute__((visibility("default")));
const char *ZSTD_getErrorName(size_t) __attribute__((visibility("default")));
int ZSTD_minCLevel(void) __attribute__((visibility("default")));
int ZSTD_maxCLevel(void) __attribute__((visibility("default")));
struct ZSTD_CCtx_s;
typedef struct ZSTD_CCtx_s ZSTD_CCtx;
ZSTD_CCtx *ZSTD_createCCtx(void) __attribute__((visibility("default")));
size_t ZSTD_freeCCtx(ZSTD_CCtx *) __attribute__((visibility("default")));
size_t ZSTD_compressCCtx(ZSTD_CCtx *, void *, size_t, const void *, size_t, int) __attribute__((visibility("default")));
struct ZSTD_DCtx_s;
typedef struct ZSTD_DCtx_s ZSTD_DCtx;
ZSTD_DCtx *ZSTD_createDCtx(void) __attribute__((visibility("default")));
size_t ZSTD_freeDCtx(ZSTD_DCtx *) __attribute__((visibility("default")));
size_t ZSTD_decompressDCtx(ZSTD_DCtx *, void *, size_t, const void *, size_t) __attribute__((visibility("default")));
typedef enum {
  ZSTD_fast = 1,
  ZSTD_dfast = 2,
  ZSTD_greedy = 3,
  ZSTD_lazy = 4,
  ZSTD_lazy2 = 5,
  ZSTD_btlazy2 = 6,
  ZSTD_btopt = 7,
  ZSTD_btultra = 8,
  ZSTD_btultra2 = 9,
} ZSTD_strategy;
typedef enum {
  ZSTD_c_compressionLevel = 100,
  ZSTD_c_windowLog = 101,
  ZSTD_c_hashLog = 102,
  ZSTD_c_chainLog = 103,
  ZSTD_c_searchLog = 104,
  ZSTD_c_minMatch = 105,
  ZSTD_c_targetLength = 106,
  ZSTD_c_strategy = 107,
  ZSTD_c_enableLongDistanceMatching = 160,
  ZSTD_c_ldmHashLog = 161,
  ZSTD_c_ldmMinMatch = 162,
  ZSTD_c_ldmBucketSizeLog = 163,
  ZSTD_c_ldmHashRateLog = 164,
  ZSTD_c_contentSizeFlag = 200,
  ZSTD_c_checksumFlag = 201,
  ZSTD_c_dictIDFlag = 202,
  ZSTD_c_nbWorkers = 400,
  ZSTD_c_jobSize = 401,
  ZSTD_c_overlapLog = 402,
  ZSTD_c_experimentalParam1 = 500,
  ZSTD_c_experimentalParam2 = 10,
  ZSTD_c_experimentalParam3 = 1000,
  ZSTD_c_experimentalParam4 = 1001,
  ZSTD_c_experimentalParam5 = 1002,
  ZSTD_c_experimentalParam6 = 1003,
  ZSTD_c_experimentalParam7 = 1004,
} ZSTD_cParameter;
typedef struct {
  size_t error;
  int lowerBound;
  int upperBound;
} ZSTD_bounds;
ZSTD_bounds ZSTD_cParam_getBounds(ZSTD_cParameter) __attribute__((visibility("default")));
size_t ZSTD_CCtx_setParameter(ZSTD_CCtx *, ZSTD_cParameter, int) __attribute__((visibility("default")));
size_t ZSTD_CCtx_setPledgedSrcSize(ZSTD_CCtx *, long long unsigned int) __attribute__((visibility("default")));
typedef enum {
  ZSTD_reset_session_only = 1,
  ZSTD_reset_parameters = 2,
  ZSTD_reset_session_and_parameters = 3,
} ZSTD_ResetDirective;
size_t ZSTD_CCtx_reset(ZSTD_CCtx *, ZSTD_ResetDirective) __attribute__((visibility("default")));
size_t ZSTD_compress2(ZSTD_CCtx *, void *, size_t, const void *, size_t) __attribute__((visibility("default")));
typedef enum {
  ZSTD_d_windowLogMax = 100,
  ZSTD_d_experimentalParam1 = 1000,
  ZSTD_d_experimentalParam2 = 1001,
} ZSTD_dParameter;
ZSTD_bounds ZSTD_dParam_getBounds(ZSTD_dParameter) __attribute__((visibility("default")));
size_t ZSTD_DCtx_setParameter(ZSTD_DCtx *, ZSTD_dParameter, int) __attribute__((visibility("default")));
size_t ZSTD_DCtx_reset(ZSTD_DCtx *, ZSTD_ResetDirective) __attribute__((visibility("default")));
]]
