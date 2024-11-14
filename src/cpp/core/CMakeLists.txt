# src/cpp/core/CMakeLists.txt

# Add core module source files
file(GLOB CORE_SOURCES *.cpp)

# Create a library for core components
add_library(core ${CORE_SOURCES})

# Include directories if needed
target_include_directories(core PUBLIC ${CMAKE_SOURCE_DIR}/include)