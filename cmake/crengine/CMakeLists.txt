list(APPEND CMAKE_ARGS -DCMAKE_KOVARS=${CMAKE_KOVARS} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})
if(NOT CMAKE_GENERATOR MATCHES "Ninja")
    list(APPEND CMAKE_ARGS -DCMAKE_TARGET_MESSAGES:BOOL=OFF)
endif()

list(APPEND BUILD_CMD COMMAND ${KO_MAKE_PROGRAM})

external_project(
    BUILD_ALWAYS
    CMAKE_ARGS ${CMAKE_ARGS}
    BUILD_COMMAND ${BUILD_CMD}
)
