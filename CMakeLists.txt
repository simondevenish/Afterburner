# Set CMake policies
cmake_policy(SET CMP0002 NEW)  # Handle duplicate target names gracefully
cmake_policy(SET CMP0079 NEW) # Allow linking targets from other directories

# Minimum CMake version
cmake_minimum_required(VERSION 3.20)

# Project name and language
project(Afterburner LANGUAGES CXX)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Output directories for built files
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Dependencies

# LAPACK, LAPACKE, and BLAS
find_package(LAPACK REQUIRED)
find_package(BLAS REQUIRED)
find_library(LAPACKE_LIBRARY lapacke REQUIRED PATHS /usr/lib/aarch64-linux-gnu /usr/local/lib)
include_directories(/usr/include)

# GSL
find_package(GSL REQUIRED)

# ZeroMQ
find_package(PkgConfig REQUIRED)
pkg_check_modules(ZMQ REQUIRED libzmq)
include_directories(${ZMQ_INCLUDE_DIRS})
link_directories(${ZMQ_LIBRARY_DIRS})
add_definitions(${ZMQ_CFLAGS_OTHER})

# spdlog
find_package(spdlog REQUIRED)

# Google Benchmark
find_package(benchmark REQUIRED)

# Protobuf
find_package(Protobuf REQUIRED)
include_directories(${Protobuf_INCLUDE_DIRS})

# SQLite
find_package(SQLite3 REQUIRED)

# Nlohmann JSON
find_package(nlohmann_json REQUIRED)

# Boost.Asio standalone (header-only)
include_directories(/usr/local/include)  # Ensure Asio headers are included

# Create a static library for shared code
add_library(AfterburnerLib STATIC)
target_sources(AfterburnerLib PRIVATE src/cpp/main.cpp)
target_include_directories(AfterburnerLib PRIVATE ${CMAKE_SOURCE_DIR}/src/cpp)

# Link dependencies to the static library
target_link_libraries(AfterburnerLib
    PRIVATE
        LAPACK::LAPACK
        BLAS::BLAS
        ${LAPACKE_LIBRARY}
        GSL::gsl
        GSL::gslcblas
        benchmark::benchmark
        spdlog::spdlog
        ${Protobuf_LIBRARIES}
        SQLite::SQLite3
        nlohmann_json::nlohmann_json
        ${ZMQ_LIBRARIES}
)

# Create the Afterburner executable
add_executable(Afterburner src/cpp/main.cpp)

# Link dependencies to the Afterburner executable
target_link_libraries(Afterburner PRIVATE AfterburnerLib)

# Enable testing
enable_testing()

# Add test executable
add_executable(AfterburnerTests tests/cpp_tests/googletest/tests.cpp)
target_link_libraries(AfterburnerTests PRIVATE AfterburnerLib benchmark::benchmark)

# Add a test target
add_test(NAME AfterburnerTests COMMAND AfterburnerTests)