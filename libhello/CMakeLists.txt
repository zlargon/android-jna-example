cmake_minimum_required(VERSION 3.0)

project(
    hello           # projectName
    VERSION 0.0.1   # [VERSION major[.minor[.patch[.tweak]]]]
    LANGUAGES C CXX # [LANGUAGES languageName ...]
)

# -fPIC, -fPIE
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)

add_library(
    hello               # create a target as a library
    # SHARED/STATIC     # ignore library type because it will be decided by 'BUILD_SHARED_LIBS'
    hello.c             # c sources
)

target_link_libraries(
    hello           # link libraries with sdk target
    PRIVATE log     # link private library
)
