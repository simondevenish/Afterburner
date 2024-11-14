#include <iostream>
#include <zmq.hpp>                    // ZeroMQ
#include <benchmark/benchmark.h>       // Google Benchmark
#include <asio.hpp>                    // Boost Asio (standalone)
#include <spdlog/spdlog.h>             // spdlog
#include <grpc/grpc.h>                 // gRPC
#include <sqlite3.h>                   // SQLite
#include <nlohmann/json.hpp>           // Nlohmann JSON
#include <gsl/gsl_rng.h>               // GNU Scientific Library
#include <lapacke.h>                   // LAPACK

void testZeroMQ() {
    zmq::context_t context(1);
    zmq::socket_t socket(context, ZMQ_REQ);
    std::cout << "ZeroMQ initialized successfully." << std::endl;
}

void testGoogleBenchmark() {
    std::cout << "Google Benchmark linked successfully." << std::endl;
}

void testBoostAsio() {
    asio::io_context io;
    std::cout << "Boost Asio initialized successfully." << std::endl;
}

void testSpdlog() {
    spdlog::info("Spdlog initialized successfully.");
}

void testGRPC() {
    grpc::ServerBuilder builder;
    std::cout << "gRPC initialized successfully." << std::endl;
}

void testSQLite() {
    sqlite3* db;
    int rc = sqlite3_open(":memory:", &db);
    if (rc == SQLITE_OK) {
        std::cout << "SQLite initialized successfully." << std::endl;
    }
    sqlite3_close(db);
}

void testJSON() {
    nlohmann::json j = {{"message", "JSON initialized successfully"}};
    std::cout << j.dump() << std::endl;
}

void testGSL() {
    gsl_rng* r = gsl_rng_alloc(gsl_rng_mt19937);
    gsl_rng_set(r, 42);
    double rand_num = gsl_rng_uniform(r);
    gsl_rng_free(r);
    std::cout << "GSL random number: " << rand_num << std::endl;
}

void testLAPACK() {
    int n = 2;
    int lda = 2;
    int ipiv[2];
    int info;
    double a[4] = {1.0, 2.0, 3.0, 4.0};
    info = LAPACKE_dgetrf(LAPACK_ROW_MAJOR, n, n, a, lda, ipiv);
    if (info == 0) {
        std::cout << "LAPACK LU decomposition succeeded." << std::endl;
    }
}

int main() {
    testZeroMQ();
    testGoogleBenchmark();
    testBoostAsio();
    testSpdlog();
    testGRPC();
    testSQLite();
    testJSON();
    testGSL();
    testLAPACK();
    return 0;
}