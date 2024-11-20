# Use a stable base image
FROM ubuntu:22.04

# Set environment variables to minimize interaction during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++

# Install core development tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-11 \
    g++-11 \
    cmake \
    pkg-config \
    libglib2.0-dev \
    libxml2-dev \
    libncurses5-dev \
    libevent-dev \
    zlib1g-dev \
    libsystemd-dev \
    libblas-dev \
    liblapack-dev \
    liblapacke-dev \
    libgsl-dev \
    libzmq3-dev \
    libssl-dev \
    libgflags-dev \
    libgtest-dev \
    libunwind-dev \
    protobuf-compiler \
    libprotobuf-dev \
    python3 \
    python3-pip \
    python3-venv \
    python3-yaml \
    git \
    xxd \
    grep \
    findutils \
    sed \
    gawk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set GCC/G++ version explicitly
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

# Verify versions
RUN gcc --version && g++ --version && cmake --version && protoc --version

# Install Protobuf
RUN git clone -b v23.3 --depth 1 https://github.com/protocolbuffers/protobuf.git /protobuf && \
    cd /protobuf && \
    git submodule update --init --recursive && \
    mkdir -p cmake/build && cd cmake/build && \
    cmake -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release ../.. && \
    make -j$(nproc) && make install && ldconfig

# Install spdlog
RUN git clone -b v1.11.0 --depth 1 https://github.com/gabime/spdlog.git /spdlog && \
    mkdir -p /spdlog/build && cd /spdlog/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && make install

# Install Google Benchmark
RUN git clone https://github.com/google/benchmark.git /benchmark && \
    git clone https://github.com/google/googletest.git /benchmark/googletest && \
    mkdir -p /benchmark/build && cd /benchmark/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && make install

# Install SQLite
RUN git clone https://github.com/sqlite/sqlite.git /sqlite && \
    cd /sqlite && \
    ./configure --prefix=/usr && make -j$(nproc) && make install

# Install Nlohmann JSON
RUN git clone -b v3.11.2 --depth 1 https://github.com/nlohmann/json.git /nlohmann_json && \
    mkdir -p /nlohmann_json/build && cd /nlohmann_json/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && make install

# Install Boost.Asio standalone (header-only)
RUN git clone -b asio-1-24-0 --depth 1 https://github.com/chriskohlhoff/asio.git /asio && \
    cp -r /asio/asio/include/asio /usr/local/include/ && \
    cp /asio/asio/include/asio.hpp /usr/local/include/ && \
    ls /usr/local/include/asio.hpp && ls /usr/local/include/asio

# Verify LAPACKE headers
RUN ls /usr/include/lapacke.h

# Set the working directory
WORKDIR /usr/src/Afterburner

# Copy the entire project into the container, excluding files in .dockerignore
COPY . .

# Fix CMake policy conflicts by explicitly setting policy CMP0079
ENV CMAKE_POLICY_DEFAULT_CMP0079=NEW

# Build the project using CMake with verbose output
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build

# Default command when the container is run
CMD ["/bin/bash"]
