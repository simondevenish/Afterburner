# tests/cpp_tests/CMakeLists.txt

# Add Google Test (assuming it's located in googletest subdirectory within cpp_tests)
add_subdirectory(googletest)

# Gather all C++ test source files
file(GLOB TEST_SOURCES "*.cpp")

# Create a test executable for C++ tests
add_executable(Afterburner_tests ${TEST_SOURCES})

# Link the test executable with Google Test and main libraries
target_link_libraries(Afterburner_tests gtest gtest_main core utils)

# Enable test discovery with CTest
include(GoogleTest)
gtest_discover_tests(Afterburner_tests)