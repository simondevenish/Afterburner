# src/cpp/utils/CMakeLists.txt

# Add utils module source files
file(GLOB UTILS_SOURCES *.cpp)

# Create a library for utility functions
add_library(utils ${UTILS_SOURCES})

# Include directories if needed
target_include_directories(utils PUBLIC ${CMAKE_SOURCE_DIR}/include)