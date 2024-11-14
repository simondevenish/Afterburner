# Minimum CMake version
cmake_minimum_required(VERSION 3.14)

# Project name and language
project(Afterburner LANGUAGES CXX)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add main source file
add_executable(Afterburner src/cpp/main.cpp)

# Find and link LAPACK and BLAS
find_package(LAPACK REQUIRED)
find_package(BLAS REQUIRED)
target_link_libraries(Afterburner PRIVATE LAPACK::LAPACK BLAS::BLAS)

# Find and link GSL
find_package(GSL REQUIRED)
target_link_libraries(Afterburner PRIVATE GSL::gsl GSL::gslcblas)

# Find and link ZeroMQ
find_package(PkgConfig REQUIRED)
pkg_check_modules(ZMQ REQUIRED libzmq)
target_link_libraries(Afterburner PRIVATE ${ZMQ_LIBRARIES})
include_directories(${ZMQ_INCLUDE_DIRS})

# Google Benchmark as an external project
include(FetchContent)
FetchContent_Declare(
    benchmark
    GIT_REPOSITORY https://github.com/google/benchmark.git
    GIT_TAG main
)
FetchContent_MakeAvailable(benchmark)

# Link Google Benchmark to Afterburner
target_link_libraries(Afterburner PRIVATE benchmark::benchmark)

# Find and link Boost Asio (standalone version)
find_path(ASIO_INCLUDE_DIRS "asio.hpp")
include_directories(${ASIO_INCLUDE_DIRS})

# Find and link spdlog
find_package(spdlog REQUIRED)
target_link_libraries(Afterburner PRIVATE spdlog::spdlog)

# Find and link gRPC
find_package(gRPC CONFIG REQUIRED)
target_link_libraries(Afterburner PRIVATE gRPC::grpc)

# Find and link SQLite
find_package(SQLite3 REQUIRED)
target_link_libraries(Afterburner PRIVATE SQLite::SQLite3)

# Find and link Nlohmann JSON (header-only)
find_package(nlohmann_json CONFIG REQUIRED)
target_link_libraries(Afterburner PRIVATE nlohmann_json::nlohmann_json)

# Include directories for the project
target_include_directories(Afterburner PRIVATE ${CMAKE_SOURCE_DIR}/src/cpp)

# Enable additional warnings
if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(Afterburner PRIVATE -Wall -Wextra -Wpedantic)
endif()